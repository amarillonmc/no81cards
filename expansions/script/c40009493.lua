--刻神编年史-久远之时少女
function c40009493.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1,1)
	c:EnableReviveLimit()	
end
