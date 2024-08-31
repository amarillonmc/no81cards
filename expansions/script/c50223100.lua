--异圣之数码兽 丧尸暴龙兽
function c50223100.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsCode,50223100),LOCATION_MZONE)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c50223100.scon)
	e2:SetTarget(c50223100.stg)
	e2:SetOperation(c50223100.sop)
	c:RegisterEffect(e2)
	--loselp
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c50223100.lpcon)
	e3:SetOperation(c50223100.lpop)
	c:RegisterEffect(e3)
	--to deck
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TODECK)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c50223100.tdcon)
	e7:SetTarget(c50223100.tdtg)
	e7:SetOperation(c50223100.tdop)
	c:RegisterEffect(e7)
end
function c50223100.spfilter(c,tp)
	return c:IsCode(50218102)
		and Duel.GetMZoneCount(tp,c)>0 and (c:IsControler(tp) or c:IsFaceup())
end
function c50223100.scon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroupEx(tp,c50223100.spfilter,1,REASON_SPSUMMON,false,nil,tp)
end
function c50223100.stg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(c50223100.spfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c50223100.sop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
end
function c50223100.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler())
end
function c50223100.lpop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc and tc:IsFaceup() and tc:GetBaseAttack()>0 then
			Duel.Hint(HINT_CARD,0,50223100)
			Duel.SetLP(tc:GetOwner(),Duel.GetLP(tc:GetOwner())-tc:GetBaseAttack())
		end
		tc=eg:GetNext()
	end
end
function c50223100.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c50223100.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c50223100.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end