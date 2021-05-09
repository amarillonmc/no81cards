--天使-赝造魔女
local m=33400751
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.cptg)
	e2:SetOperation(cm.cpop)
	c:RegisterEffect(e2)
 --chain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(cm.chop)
	c:RegisterEffect(e3)
end
function cm.cpfilter(c,tp)
	return c:IsFaceup() and Duel.IsExistingTarget(cm.cpfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,c,c)
end
function cm.cpfilter2(c,mc)
	return c:IsFaceup() and  not c:IsCode(mc:GetCode()) and c:IsSetCard(0x3342)
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		return Duel.IsExistingTarget(cm.cpfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp)  
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local g1=Duel.SelectTarget(tp,cm.cpfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	local g2=Duel.SelectTarget(tp,cm.cpfilter2,tp,LOCATION_ONFIELD+ LOCATION_GRAVE,0,1,1,g1:GetFirst(),g1:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local lc=tg:GetFirst()
	if lc==tc then lc=tg:GetNext() end
	local cd=lc:GetCode()
	if lc:IsRelateToEffect(e) and lc:IsControler(tp) and  tc:IsFaceup() and tc:IsRelateToEffect(e)  then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(cd)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1) 
		if tc:IsControler(1-tp) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e2,true)
		end
	end
end

function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	   --ChainLimit
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetOperation(cm.chainop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0x3342) and ep==tp then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end



