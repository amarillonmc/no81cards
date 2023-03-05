--天花乱漫-春花烂漫
local m=14001215
local cm=_G["c"..m]
cm.named_with_Blossom_Blade=1
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.setcon)
	e3:SetTarget(cm.settg)
	e3:SetOperation(cm.setop)
	c:RegisterEffect(e3)
end
function cm.BB(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Blossom_Blade
end
function cm.posfilter(c)
	return c:IsPosition(POS_ATTACK)
end
function cm.posfilter1(c)
	return c:IsPosition(POS_ATTACK) and c:IsCanChangePosition()
end
function cm.negfilter(c)
	return aux.NegateMonsterFilter(c) and c:IsPosition(POS_ATTACK)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cm.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g1=Duel.GetMatchingGroup(cm.posfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.ChangePosition(g1,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE)
		local og=g:Filter(cm.negfilter,nil)
		if #og>0 then
			local tc=og:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				tc=g:GetNext()
			end
		end
	end
end
function cm.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and cm.BB(c) and c:IsFaceup()
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.setfilter(c)
	return cm.BB(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		if Duel.SSet(tp,g)~=0 then
			local tc=g:GetFirst()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			tc:RegisterEffect(e2)
		end
	end
end