--死龙·玻吕刻斯
xiadie=xiadie or {}
xiadie.loaded_metatable_list={}


local cm,m,o=GetID()
function cm.initial_effect(c)
	
end
function xiadie.precheck(c)
	aux.AddCodeList(c,60001275)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EVENT_PREDRAW)
	e0:SetRange(LOCATION_HAND+LOCATION_DECK)
	e0:SetOperation(xiadie.checkop)
	c:RegisterEffect(e0)
end
function xiadie.accheck(e)
	if Duel.GetFlagEffect(e:GetHandlerPlayer(),60001275)==0 then return false
	else return true end
end
function xiadie.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnCount()~=1 then return end
	
	if not xiadie.SpaceCheck then
		xiadie.SpaceCheck=1
		if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,nil,TYPE_MONSTER)==0 then
			Duel.RegisterFlagEffect(tp,60001275,0,0,1)
		end
	else return end
end

function xiadie.damage(e)
	local tp=e:GetHandlerPlayer()
	local num=Duel.GetFlagEffect(tp,60001276)*100+100
	if Duel.Damage(1-tp,num,REASON_EFFECT)~=0 then 
		Duel.RegisterFlagEffect(tp,60001276,0,0,1) 
		return true 
	else return false end
end