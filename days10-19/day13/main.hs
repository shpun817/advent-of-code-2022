filename :: String
-- filename = "dummy_input.txt"
filename = "input.txt"

-- Source: https://stackoverflow.com/a/4981265
wordsWhen :: (Char -> Bool) -> String -> [String]
wordsWhen pred str = case dropWhile pred str of
                        ""   -> []
                        str' -> w : wordsWhen pred str''
                                where (w, str'') = break pred str'

groupPairs :: [String] -> [(String, String)]
groupPairs items = aux items []
                    where
                        aux items acc
                          | null items  = acc
                          | otherwise   = aux (tail $ tail items) (acc ++ [(head items, head $ tail items)])

enumerate :: [a] -> [(Integer, a)]
enumerate items = aux items 1 []
                    where
                        aux items index acc
                          | null items  = acc
                          | otherwise   = aux (tail items) (index+1) (acc ++ [(index, head items)])
                          
-- Parse helpers

isOpenBrac :: Char -> Bool
isOpenBrac c = c == '['

isCloseBrac :: Char -> Bool
isCloseBrac c = c == ']'

isComma :: Char -> Bool
isComma c = c == ','

isDigit :: Char -> Bool
isDigit c = c `elem` "0123456789"

parseList :: String -> [String] -- Assumes input string does not have leading and trailing brackets
parseList raw = aux raw [] 0 []
                    where
                        aux raw bracBuf bracAcc acc
                          | null raw                                = acc
                          | isCloseBrac c && not isFinishingBrac    = aux (tail raw) appendedBuf (bracAcc-1) acc
                          | isCloseBrac c && isFinishingBrac        = aux (tail raw) [] 0 (acc ++ [appendedBuf])
                          | isOpenBrac c                            = aux (tail raw) appendedBuf (bracAcc+1) acc
                          | isComma c && not isOutmostLvl           = aux (tail raw) appendedBuf bracAcc acc
                          | isComma c && isOutmostLvl               = aux (tail raw) bracBuf bracAcc acc
                          | isDigit c && not isOutmostLvl           = aux rest (bracBuf ++ number) bracAcc acc
                          | isDigit c && isOutmostLvl               = aux rest bracBuf bracAcc (acc ++ [number])
                          | otherwise                               = ["Invalid"]
                            where c = head raw
                                  appendedBuf = bracBuf ++ [c]
                                  (number, rest) = span isDigit raw
                                  isOutmostLvl = bracAcc == 0
                                  isFinishingBrac = bracAcc == 1

-- End parse helpers

-- Comparison logic

data Order = Correct | Incorrect | TBD deriving (Enum, Eq)

isInRightOrder :: (String, String) -> Bool
isInRightOrder pair = do
    let res = isInRightOrderSS pair
    res == Correct || res == TBD

isInRightOrderSS :: (String, String) -> Order -- Assumes input strings are whole values (lists or numbers)
isInRightOrderSS (left, right) = do
    let leftIsList = isOpenBrac $ head left
    let rightIsList = isOpenBrac $ head right

    case (leftIsList, rightIsList) of
        -- Both integers
        (False, False) -> isInRightOrderII (read left, read right)
        -- Both lists
        (True, True) -> isInRightOrderLLRaw (left, right)
        -- (List, Integer)
        (True, False) -> isInRightOrderLLRaw (left, ['['] ++ right ++ [']'])
        -- (Integer, List)
        (False, True) -> isInRightOrderLLRaw (['['] ++ left ++ [']'], right)

isInRightOrderII :: (Integer, Integer) -> Order
isInRightOrderII (left, right) = case compare left right of
                                    LT -> Correct
                                    GT -> Incorrect
                                    EQ -> TBD

isInRightOrderLLRaw :: (String, String) -> Order -- Assumes input strings are whole lists (with leading and trailing brackets)
isInRightOrderLLRaw (left, right) = do
    let leftList = parseList $ tail $ init left
    let rightList = parseList $ tail $ init right
    isInRightOrderLL (leftList, rightList)
    
isInRightOrderLL :: ([String], [String]) -> Order
isInRightOrderLL ([], []) = TBD
isInRightOrderLL ([], right) = Correct
isInRightOrderLL (left, []) = Incorrect
isInRightOrderLL (left, right) = do
    let res = isInRightOrderSS (head left, head right)
    if res == TBD
        then isInRightOrderLL(tail left, tail right)
        else res

-- End comparison logic

main :: IO()
main = do
    inputStr <- readFile filename
    
    let packets = wordsWhen (=='\n') inputStr
    
    let pairs = groupPairs packets
    
    let enumeratedPairs = enumerate pairs
    
    let pairsInRightOrder = filter (\(_, pair) -> isInRightOrder pair) enumeratedPairs
    
    let indPairsInRightOrder = map fst pairsInRightOrder
    
    let sumIndices = sum indPairsInRightOrder
    
    putStrLn $ "Part 1: " ++ show sumIndices
