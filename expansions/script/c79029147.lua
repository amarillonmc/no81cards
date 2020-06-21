--深海猎人·近卫干员-斯卡蒂·跃浪击
function c79029147.initial_effect(c)
	c:EnableReviveLimit()   
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c79029147.spcon)
	e1:SetTarget(c79029147.sptg)
	e1:SetOperation(c79029147.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c79029147.descon)
	e2:SetTarget(c79029147.destg)
	e2:SetOperation(c79029147.desop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c79029147.tdtg)
	e3:SetOperation(c79029147.tdop)
	c:RegisterEffect(e3)
end
function c79029147.sprfilter(c)
	return c:IsCode(79029010) and c:IsAbleToGraveAsCost()
end
function c79029147.fselect(g,tp)
	return Duel.GetMZoneCount(tp,g)>0
end
function c79029147.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c79029147.sprfilter,tp,LOCATION_HAND,0,nil)
	return g:CheckSubGroup(c79029147.fselect,1,1,tp)
end
function c79029147.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c79029147.sprfilter,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c79029147.fselect,true,1,1,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return Duel.CheckLPCost(tp,3000)
	else return false end
end
function c79029147.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	Duel.PayLPCost(tp,3000)
	Duel.SendtoGrave(g,REASON_COST)
	g:DeleteGroup()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetAttack()*2)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e1)
	Debug.Message("别眨眼，你会错过自己的死状。")
end
function c79029147.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c79029147.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c79029147.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
	Debug.Message("生疏了吗？到手的赏金会变少哟。")
end
function c79029147.filter(c)
	return (c:IsCode(79029010) or c:IsCode(79029150)) and c:IsFaceup()
end
function c79029147.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029147.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c79029147.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,c79029147.filter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then 
	local tc=g:GetFirst()
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	Debug.Message("起舞吧。")
	end
end









