--整合运动·酸液源石虫
function c79020005.initial_effect(c)
	--nontuner
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_NONTUNER)
	e1:SetValue(c79020005.tnval)
	c:RegisterEffect(e1)   
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_DECK)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c79020005.drtg)
	e2:SetOperation(c79020005.dsop)
	e2:SetCountLimit(1,79020005)
	c:RegisterEffect(e2)  
end
function c79020005.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end
function c79020005.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c79020005.dsop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_DECK+LOCATION_EXTRA,nil,ac)
	if g:GetCount()>0 then
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end
end