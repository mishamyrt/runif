import Cocoa

class EventObserver: EventListener, EventProvider {
    var listener: EventListener?

    var providers: Array<SourceEventProvider> = []

    init(providers: Array<SourceEventProvider>) {
        for var provider in providers {
            provider.listener = self
        }
        self.providers = providers
    }

    func handleEvent(with: Event) {
        print(with)
        if (self.listener != nil) {
            self.listener!.handleEvent(with: with)
        }
    }

    func runLoop() {
        _ = NSApplication.shared
        let ticket = Timer.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.run()
            }
        RunLoop.main.run()
        ticket.cancel()
    }

    func run() {
        for provider in self.providers {
            provider.handle()
        }
    }
}
