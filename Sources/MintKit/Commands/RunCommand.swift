import Foundation
import Utility

class RunCommand: PackageCommand {

    var commandArgument: PositionalArgument<[String]>!
    var silentArgument: OptionArgument<Bool>!

    init(mint: Mint, parser: ArgumentParser) {
        super.init(mint: mint, parser: parser, name: "run", description: "Install and then run a package")
        commandArgument = subparser.add(positional: "command", kind: [String].self, optional: true, strategy: .remaining, usage: "The command to run. This will default to the package name")
        silentArgument = subparser.add(option: "--silent", kind: Bool.self, usage: "Silences any output from Mint itself")
    }

    override func execute(parsedArguments: ArgumentParser.Result, repo: String, version: String, verbose: Bool) throws {
        var arguments = parsedArguments.get(commandArgument)
        let silent = parsedArguments.get(silentArgument) ?? false
        // backwards compatability for arguments surrounded in quotes
        if let args = arguments,
            args.count == 1,
            let firstArg = args.first,
            firstArg.contains(" ") {
            arguments = firstArg.split(separator: " ").map(String.init)
        }
        if silent {
            mint.standardOutput = { _ in }
        }
        try mint.run(repo: repo, version: version, verbose: verbose, arguments: arguments)
    }
}
