--破灭之俑甲
local m=33330176
local cm=_G["c"..m]
Duel.LoadScript("c81000000.lua")
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c:IsCanChangePosition() or c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.cfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.cfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local lsp=0
	if tc:IsCanChangePosition() then
		lsp=lsp+1
	end
	if tc:IsAbleToRemove() then
		lsp=lsp+10
	end
	if lsp==1 then
		opt=Duel.SelectOption(1-tp,aux.Stringid(m,0))
	elseif lsp==10 then
		opt=Duel.SelectOption(1-tp,aux.Stringid(m,1))+1
	else
		opt=Duel.SelectOption(1-tp,aux.Stringid(m,0),aux.Stringid(m,1))
	end
	if opt==0 then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		if tc:IsPosition(POS_FACEUP_ATTACK) then
			local atk=tc:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(0)
			tc:RegisterEffect(e1)
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		else
			local def=tc:GetDefense()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(0)
			tc:RegisterEffect(e1)
			Duel.Damage(1-tp,def,REASON_EFFECT)
		end
	else
		local atc=tc:GetBaseAttack()
		local dtc=tc:GetBaseDefense()
		if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
			Duel.Recover(tp,atc+dtc,REASON_EFFECT)
		end
	end
end
