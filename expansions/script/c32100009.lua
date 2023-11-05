--假面骑士 OOO
function c32100008.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,32100002,aux.FilterBoolFunction(Card.IsFusionSetCard,0xa9),3,3,true,true) 

end 




