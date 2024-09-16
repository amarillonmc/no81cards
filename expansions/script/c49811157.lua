--きらきら黒光りするG
function c49811157.initial_effect(c)
	--change name
    aux.EnableChangeCode(c,94081496,LOCATION_GRAVE)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49811157,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_ANNOUNCE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCountLimit(1,49811157)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c49811157.condition)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c49811157.target)
	e1:SetOperation(c49811157.operation)
	c:RegisterEffect(e1)
end
function c49811157.ctfilter(c)
    return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c49811157.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c49811157.ctfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c49811157.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION | TYPE_SYNCHRO | TYPE_XYZ | TYPE_LINK | TYPE_PENDULUM,OPCODE_ISTYPE}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c49811157.operation(e,tp,eg,ep,ev,re,r,rp)
	local ga=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
    Duel.ConfirmCards(tp,ga)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_EXTRA,nil,ac)
	if g:GetCount()>0 then
		local tg=g:Select(tp,1,1,nil)
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		Duel.ShuffleExtra(1-tp)
	end
end
