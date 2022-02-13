local m=188886
local cm=_G["c"..m]
cm.name="星魅真龙-启示德里斯"
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(cm.valcheck)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTarget(function(e,c)return c:IsSetCard(0xca2) and c:IsRace(RACE_WYRM)end)
	e1:SetValue(700)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.mvcon)
	e3:SetTarget(cm.mvtg)
	e3:SetOperation(cm.mvop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,3))
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_MOVE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.drcon)
	e4:SetTarget(cm.drtg)
	e4:SetOperation(cm.drop)
	c:RegisterEffect(e4)
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsLinkCode,1,nil,188874) then c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0)) end
end
function cm.mvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)>0
end
function cm.mvfilter(c,g)
	return c:IsFaceup() and c:IsSetCard(0xca2) and g:IsContains(c)
end
function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.mvfilter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler():GetLinkedGroup()) and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	local g=Duel.SelectMatchingCard(tp,cm.mvfilter,tp,LOCATION_MZONE,0,1,1,nil,e:GetHandler():GetLinkedGroup())
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		Duel.MoveSequence(g:GetFirst(),nseq)
	end
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(m)==0 then return false end
	local g=eg:Filter(function(c)return c:IsLocation(LOCATION_ONFIELD) and c:IsPreviousLocation(LOCATION_ONFIELD)end,nil)
	if g:GetCount()==0 then return false end
	e:SetLabel(0)
	if g:IsExists(function(c,g)return g:IsContains(c)end,1,nil,e:GetHandler():GetLinkedGroup()) then e:SetLabel(1) end
	return true
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 and e:GetLabel()==1 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
