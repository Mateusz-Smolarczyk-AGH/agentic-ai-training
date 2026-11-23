---
title: AI agent memory: How LLM agents manage state in production
source_url: https://blog.n8n.io/ai-agent-memory-how-llm-agents-manage-state-in-production
publisher: n8n Blog
published: 2026-10-23
retrieved: 2026-11-17
type: engineering-blog
topic: LLM Wiki / agent-native wikis and knowledge bases for LLMs (SOTA 2026)
---

# AI agent memory: How LLM agents manage state in production
Learn how AI agent memory works, explore short-term and long-term memory architectures, and discover how to combine n8n and Cognee to build AI workflows that retain context, share knowledge, and learn across sessions.
![n8n team](https://www.gravatar.com/avatar/1eae00944b78b70ae368cb7f7185d8f6?s=250&r=x&d=mp)
[n8n team](https://blog.n8n.io/author/marketing/)
October 23, 2026 ∙ 10-minute read 
![AI agent memory: How LLM agents manage state in production](https://storage.ghost.io/c/0d/78/0d78b34c-0c5f-4975-900e-61d00ccb1c2d/content/images/size/w800/2026/10/Minimalist-Audio-Flow-Diagram.png)
  1. [Every LLM call starts from zero](https://blog.n8n.io/ai-agent-memory-how-llm-agents-manage-state-in-production/#every-llm-call-starts-from-zero)
  2. [Short-term and long-term memory](https://blog.n8n.io/ai-agent-memory-how-llm-agents-manage-state-in-production/#short-term-and-long-term-memory)
  3. [LLM memory, context, RAG, agent memory: what's the difference?](https://blog.n8n.io/ai-agent-memory-how-llm-agents-manage-state-in-production/#llm-memory-context-rag-agent-memory-whats-the-difference)
  4. [How agent memory actually works](https://blog.n8n.io/ai-agent-memory-how-llm-agents-manage-state-in-production/#how-agent-memory-actually-works)
  5. [Memory has to be managed, not just accumulated](https://blog.n8n.io/ai-agent-memory-how-llm-agents-manage-state-in-production/#memory-has-to-be-managed-not-just-accumulated)
  6. [How do you know your memory works?](https://blog.n8n.io/ai-agent-memory-how-llm-agents-manage-state-in-production/#how-do-you-know-your-memory-works)
  7. [Adding n8n workflows memory](https://blog.n8n.io/ai-agent-memory-how-llm-agents-manage-state-in-production/#adding-n8n-workflows-memory)
    1. [1. A shared brain for all your workflows](https://blog.n8n.io/ai-agent-memory-how-llm-agents-manage-state-in-production/#1-a-shared-brain-for-all-your-workflows)
    2. [2. Memory inside an agentic workflow](https://blog.n8n.io/ai-agent-memory-how-llm-agents-manage-state-in-production/#2-memory-inside-an-agentic-workflow)
  8. [Conclusion](https://blog.n8n.io/ai-agent-memory-how-llm-agents-manage-state-in-production/#conclusion)


💡
This is a guest post written by Veljko Kovac, Head of FDE at [Cognee](https://www.cognee.ai/), an open-source agent memory platform.
## Every LLM call starts from zero
An LLM has no memory of its own. Each request is independent: the model reads the prompt, returns a response, and keeps nothing. Send a second request and, as far as the model knows, the first never happened.
That is fine for a one-shot question. It breaks down the moment you build something that works over time: a support agent handling a follow-up, a sales assistant prepping for a renewal call, or a workflow that runs every hour and should know what it did last time. These systems need **state** , and the model can't hold it for them.
![](https://storage.ghost.io/c/0d/78/0d78b34c-0c5f-4975-900e-61d00ccb1c2d/content/images/2026/10/data-src-image-6c845b53-7aee-44f7-a87e-360d9be4cfac.png)
So when people ask how LLM memory works, the honest answer is that the memory lives outside the model. The agent stores what it learns somewhere else, retrieves the relevant parts before each call, and feeds them back into the prompt. That external layer is what we call [_AI agent memory_](https://www.cognee.ai/agent-memory?utm_source=n8n&utm_campaign=agent_memory_guest_post), and how you design it decides whether your agent remembers the right things or drowns in the wrong ones.
This post explains how that layer works, the main ways to build it, and how to use it in [_n8n_](https://n8n.io/), both as a shared "company brain" your workflows can query and as memory inside a single agentic workflow.
## Short-term and long-term memory
Agent memory usually works on two timescales, and they are often built as two separate components.
**Short-term memory** keeps track of what's happening right now: recent messages, intermediate reasoning, tool outputs, the state of the task. It lives close to the agent, often inside the harness itself. When the context window fills up, a common trick is to summarize the history so far and feed the summary back in. That works until it doesn't: summaries lose detail, and some outputs shouldn't be compressed at all, for example intermediate drafts or the results of expensive computations.
**Long-term memory** survives across sessions. It holds user preferences, outcomes of past tasks, lessons about what worked, and increasingly, company knowledge the agent didn't generate itself: docs, tickets, CRM records. This almost always needs a dedicated external layer from day one, because something has to decide what gets kept, how it's organized, and what comes back for each request.
Either way, the delivery mechanism doesn't change. The model still receives one prompt. Memory just changes how that prompt is assembled: the new user message, plus the running session, plus whatever long-term memories are relevant right now.
![](https://storage.ghost.io/c/0d/78/0d78b34c-0c5f-4975-900e-61d00ccb1c2d/content/images/2026/10/data-src-image-cb8f4abb-afc5-4f6a-b9da-bddd63517293.png)
## LLM memory, context, RAG, agent memory: what's the difference?
These four terms get used interchangeably, but they describe different places where knowledge can live. A real system often uses all of them.  
| Approach  | Where knowledge lives  | Who updates it  | Good for  |  
| --- | --- | --- | --- |  
| LLM memory (model weights)  | Inside the model  | Training or fine-tuning  | General knowledge and skills  |  
| Context engineering  | The current prompt  | Agent harness or application code, on every call  | Getting the right data into this request  |  
| RAG  | An external, mostly static corpus  | People or systems writing documents  | Grounding answers in existing knowledge  |  
| Agent memory  | An external memory layer that keeps evolving  | People, data pipelines, and the agent itself  | Continuity across tasks, sessions and sources  |  
**LLM memory** in the strict sense is what the model absorbed during training. It's compressed patterns, not a lookup table, which is why a model can confidently repeat something outdated. Fine-tuning can add domain knowledge, but it's slow, expensive, hard to inspect, and it can't capture anything from a live session.
**Context engineering** is choosing what goes into the context window for this particular call. Bigger windows help, but they don't solve memory: the context vanishes when the session ends, long prompts cost more, and models don't attend equally to everything in a very long input.
**RAG** retrieves from an existing knowledge source (docs, a database, an API) and adds the results to the prompt. The key limitation is direction: RAG reads, but it doesn't write back. It won't remember what the user asked last week or which fix already failed.
**Agent memory** starts where the agent writes back. It captures new facts, preferences and outcomes as it works, and retrieves them later. Picture a sales assistant that pulls this quarter's numbers via RAG, but also remembers from earlier conversations that this user wants EU figures in euros, broken down by country. 
## How agent memory actually works
At a high level, any memory system needs three pieces: a data store where memories are persisted, write logic that decides what gets stored and how, and a retrieval interface that lets the agent find the relevant memories. The store you choose has a big influence on the other two: which write logic makes sense, and what retrieval can do. So here are the main architectures, by store type.
**Vector databases.** Memories are turned into embeddings and found by semantic similarity. Easy to set up and well supported, but similarity isn't everything. "Q3 sales" and "Q4 sales" sit almost on top of each other in vector space, there's no notion of which fact is current, and an entry that's relevant but phrased differently can be missed entirely.
**Plain files.** The agent keeps a MEMORY.md (or similar) that it reads and edits. Coding agents popularized this. It's transparent and version-controlled, but retrieval is limited to loading everything or grep-ping, and sharing a file between many agents gets messy fast.
**Knowledge graphs.** Facts become entities and relationships: the sales report _covers_ EU deals, EU deals are _booked in_ euros, the figures _come from_ the billing export. Retrieval finds an entry point, then follows the edges, so the agent gets facts that are _logically_ related to the question, not only ones that sound similar. The trade-off is more work at ingestion time.
**Hybrid systems.** In practice, no single store covers everything. Exact IDs want a structured index, relationships want a graph, fuzzy matching wants vectors, and "what did the customer prefer last March?" needs timestamps. Production memory layers combine stores and put logic on top that decides what goes where. This is also why a memory layer is more than a database: the stores are just where the data lives, and the memory layer sits on top of them. It decides what gets stored and in what form, and exposes the operations agents use to write, retrieve, update and forget.  
| Architecture  | Retrieval  | Strength  | Watch out for  |  
| --- | --- | --- | --- |  
| Vector database  | Semantic similarity  | Simple, scalable, mature tooling  | No entities, weak on exact IDs, no recency  |  
| Files  | Load all or search text  | Transparent, versioned, no infra  | Doesn't scale or share well  |  
| Knowledge graph  | Entry point, then traverse edges  | Related facts, explainable paths  | More complex to build and maintain  |  
| Hybrid  | Several stores in one layer; logic on top routes each query across stores  | Covers mixed data: exact IDs, relationships, fuzzy matches and time-aware queries  | Needs more components to set up and run  |  
## Memory has to be managed, not just accumulated
A memory layer that only grows gets worse over time. Facts change, preferences shift, and stale entries start competing with correct ones. Good memory systems handle several processes on top of storage. The main three are:
  * **Consolidation.** Raw entries pile up faster than they become useful. The system should periodically turn them into fewer, higher-level records (summaries, derived facts) while keeping a trail back to the originals.
  * **Updating.** When a fact changes, a blind overwrite loses history: what was true before, and when it changed. Keeping time information on facts lets the agent answer both "what's true now?" and "what did we believe in March?"
  * **Forgetting.** Some data has to go: a stale dataset, a correction, a deletion request. That should be an explicit, deliberate operation, separate from the softer job of letting less useful memories fade in relevance.


**The best systems also learn from use**. If an answer gets confirmed, the memories behind it gain weight; if it gets corrected, the misleading ones drop. Over weeks, retrieval should get sharper, not noisier.
## How do you know your memory works?
Public benchmarks give a useful first signal. Most follow the same two-phase pattern: feed a long history into the memory system, then ask questions whose answers depend on storing and retrieving the right facts, including ones that were later updated or contradicted.
Size matters more than people expect. If a benchmark's whole history fits in a modern context window, you can skip memory entirely and paste everything into the prompt, so the test says more about the model than about the memory. That doesn't mean the model will answer perfectly, though: models don't use long contexts evenly, and details buried in the middle of a long prompt can get less attention. LoCoMo conversations run around 26k tokens; LongMemEval's common variant is about 115k. BEAM is the most demanding of the three, testing ten memory abilities over conversations of up to 10M tokens, which is where external memory actually has to do the work. The reported state of the art on BEAM is 79% at 100K tokens and 67% at 10M, [_set by Cognee_](https://www.cognee.ai/benchmarking-cognee-on-beam?utm_source=n8n&utm_campaign=agent_memory_guest_post), up from the previous best of 73.4% and 64.1%.
But benchmarks mostly check final answers. They don't look at what the memory actually stored, how it holds up after weeks of updates, or how it behaves when many agents share it. For a full map of what each benchmark measures and where it falls short, see this guide to [_AI memory benchmarks_](https://www.cognee.ai/ai-memory-benchmarks?utm_source=n8n&utm_campaign=agent_memory_guest_post).
The test that matters most is your own: run the same workflow with memory on and off, and measure the outcome you care about, such as tickets resolved, fewer repeated questions, or correct follow-ups.
## Adding n8n workflows memory
n8n workflows share a trait with LLMs: by default, each execution starts fresh. So a support workflow that drafted a fix on Monday won't automatically know about it when a follow-up arrives on Wednesday. Many teams handle this with a Postgres table or an Airtable base, which works, but each workflow then needs its own storage setup and its own rules for what to keep.
### 1. A shared brain for all your workflows
At its simplest, memory lets any workflow pick up where the last run left off. One node stores what the workflow learned; another looks it up on the next run. And because the memory lives outside any single workflow, many workflows can share it.
The biggest payoff is a centralized "brain": one shared memory that all your workflows write to and read from. Extend it to the whole company and you get a "company brain". Most useful context already exists across the company: Slack threads, tickets, docs, CRM notes, call transcripts. n8n can collect it from all those tools, and a memory layer can structure and connect it, so every workflow draws on the same picture of what the company knows.
The pattern is simple:
  * **Collector workflows** use n8n's triggers and app integrations to pick up new material as it appears, such as a closed ticket, a call summary or a form submission, and send it to the memory layer, which structures and connects it.
  * **Acting workflows** query that same memory right before they do something: draft a reply, route an escalation, prep a sales brief. They can ask in plain English, like "What's the current status with Acme, and what did we promise them?", and pass the answer on to the next node.


Because both sides point at the same memory, workflows share context without sharing implementation details. And when the memory keeps relationships between entities, acting workflows get connected answers, such as which contracts expire next quarter or which accounts share the same root cause, that a pure similarity search would miss.
![](https://storage.ghost.io/c/0d/78/0d78b34c-0c5f-4975-900e-61d00ccb1c2d/content/images/2026/10/data-src-image-06c5a092-a8ab-4d07-be13-2879d82cc78a.png)
### 2. Memory inside an agentic workflow
The second pattern lives inside a single n8n AI Agent, and it maps onto the short-term and long-term split from earlier. Without memory, every message the agent receives starts from zero. n8n handles the short-term side through the AI Agent's **Memory** port. n8n's default, "Simple Memory", stores a customizable length of chat history for the current session, and it's the easiest way to get started. You can stick with this default or choose a more advanced third-party memory provider, as shown below: 
![](https://storage.ghost.io/c/0d/78/0d78b34c-0c5f-4975-900e-61d00ccb1c2d/content/images/2026/10/image--1---1-.png)
Chat memory, though, only remembers the conversation. Long-term knowledge, such as user preferences, the outcomes of past tasks and company context, needs more than a chat log. For that, connect a memory layer to the Agent's **Tool** port, where you attach add-ons the agent can use to access extra context or resources. The agent can then decide for itself when to remember something new and when to search what the company already knows. The result is an agent that holds the thread of the current conversation _and_ can reach into shared company knowledge mid-task.
In short: n8n's built-in memory is a good starting point for a single chat agent. But if you want memory that evolves over time and is shared across workflows and agents, combine it with a memory layer: chat memory for the conversation at hand, and shared memory so every run starts from what the company already knows rather than from zero.
## Conclusion
LLMs start every call from zero, so building AI agents that work reliably over time requires memory outside the model. But storing information is only half the challenge. Agents also need a way to capture, retrieve, and act on the right context across tasks and workflows.
**n8n and Cognee solve these challenges together.** n8n connects your apps, orchestrates AI agents, and automates how information flows between systems. Cognee turns that information into structured, persistent memory that agents can retrieve, update, and share.
Together, they let you build AI workflows that don't just execute tasks independently, but learn from previous interactions, maintain context across sessions, and work from a shared understanding of your company's knowledge.
**Ready to build AI agents with long-term memory?** [Get started with n8n](https://n8n.io/) and [connect Cognee](https://platform.cognee.ai/sign-up?utm_source=n8n&utm_campaign=agent_memory_guest_post) to give your workflows a shared memory layer.
## Share with us
n8n users come from a wide range of backgrounds, experience levels, and interests. We have been looking to highlight different users and their projects in our blog posts. If you're working with n8n and would like to inspire the community, [contact us](https://n8n-community.typeform.com/to/VYiRI7WN?ref=blog.n8n.io) 💌
SHARE
[ ](https://blog.n8n.io/ai-agent-memory-how-llm-agents-manage-state-in-production/) [ ](https://twitter.com/intent/tweet?text=AI%20agent%20memory%3A%20How%20LLM%20agents%20manage%20state%20in%20production&url=https://blog.n8n.io/ai-agent-memory-how-llm-agents-manage-state-in-production/) [ ](https://www.linkedin.com/sharing/share-offsite/?url=https://blog.n8n.io/ai-agent-memory-how-llm-agents-manage-state-in-production/)
### [Introducing n8n 3.0 Newer post ](https://blog.n8n.io/introducing-n8n-v3/) ### [Hallucination detection methods for AI agent workflows Older post ](https://blog.n8n.io/hallucination-detection-methods-for-ai-agent-workflows/)
## Other guides to get you going
## Where there's a will, there's already a workflow
[ ![](https://blog.n8n.io/assets/images/home/footer-logo-symbol.svg?v=Xr0lRykIgzd8Sw7s) ![](https://blog.n8n.io/assets/images/home/footer-logo-wordmark.svg?v=-obSSX3EH290Qfw2) ](https://blog.n8n.io)
Automate without limits
[![](https://blog.n8n.io/assets/images/home/social-x.svg?v=dODylUSK0bY34zWW)](https://x.com/n8n_io) [![](https://blog.n8n.io/assets/images/home/social-github.svg?v=-IB7C6yW-rzpuOqR)](https://github.com/n8n-io/n8n) [![](https://blog.n8n.io/assets/images/home/social-discord.svg?v=mwwLw2uKx5-7p_sd)](https://discord.gg/n8n) [![](https://blog.n8n.io/assets/images/home/social-linkedin.svg?v=30MF2IACqph-y4A2)](https://www.linkedin.com/company/n8n/) [![](https://blog.n8n.io/assets/images/home/social-youtube.svg?v=Em6ZoW7PcHkdThtj)](https://www.youtube.com/c/n8n-io)
  * [Website](https://n8n.io/)
  * [Features](https://n8n.io/features/)
  * [Pricing](https://n8n.io/pricing/)
  * [Docs](https://docs.n8n.io/)
  * [Community](https://community.n8n.io/)


[Imprint](https://n8n.io/imprint/) ![](https://blog.n8n.io/assets/images/home/bullet.svg?v=hyw47kEFGTd22KaJ) [Security](https://n8n.io/legal/security/) ![](https://blog.n8n.io/assets/images/home/bullet.svg?v=hyw47kEFGTd22KaJ) [Privacy](https://n8n.io/legal/privacy/) ![](https://blog.n8n.io/assets/images/home/bullet.svg?v=hyw47kEFGTd22KaJ) [Report a vulnerability](https://n8n.io/legal/vulnerability-disclosure-policy/)
© 2026 n8n | All rights reserved.
