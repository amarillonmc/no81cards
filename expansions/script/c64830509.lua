--「为了适应超出我体系的环境」
local m=64830509
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,64830500)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.con)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(cm.descon)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function cm.con(e,tp)
	local f=function(c)
		return c:IsFacedown() or not c:IsType(TYPE_NORMAL)
	end
	return not Duel.IsExistingMatchingCard(f,tp,LOCATION_MZONE,0,1,nil)
end
function cm.cfilter(c,e,tp)
	if not (c:IsCode(64830500) or (c:IsFaceup() and c:IsLocation(LOCATION_MZONE))) then return false end
	if c:IsLocation(LOCATION_GRAVE) then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
	else return true
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
		((chkc:IsLocation(LOCATION_GRAVE) and chkc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or chkc:IsLocation(LOCATION_MZONE)) and chkc:IsFaceup() and chkc:IsControler(tp) and chkc:IsCode(64830500)
	end
	if chk==0 then return Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,cm.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op(e,tp)
	local tc=Duel.GetFirstTarget()
	local c=aux.ExceptThisCard(e)
	if not c then return end
	if not tc:IsRelateToEffect(e) and c then Duel.SendtoGrave(c,REASON_RULE) return end
	if tc and c then
		if tc:IsLocation(LOCATION_GRAVE) then
			if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)<1 then Duel.SendtoGrave(c,REASON_RULE) return end
		end
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(function() return Duel.IsMainPhase() end)
		e1:SetTarget(cm.settg)
		e1:SetOperation(cm.setop)
		c:RegisterEffect(e1)
	end
end
function cm.setfilter(c)
	return aux.IsCodeListed(c,64830500) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		if tc:IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		elseif tc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end