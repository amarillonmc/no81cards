local m=53721008
local cm=_G["c"..m]
cm.name="悚牢之壁 幼怪鱼"
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.SorisonFish(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(SNNM.SorisonTGCondition)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
end
function cm.setfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and (cm.setfilter(chkc) or aux.nzatk(chkc)) end
	if chk==0 then return true end
	local b1=Duel.IsExistingTarget(cm.setfilter,tp,0,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingTarget(aux.nzatk,tp,0,LOCATION_MZONE,1,nil)
	local op=3
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(m,2))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_POSITION)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectTarget(tp,cm.setfilter,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	elseif op==1 then
		e:SetCategory(CATEGORY_ATKCHANGE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,1,nil)
	end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		end
	elseif e:GetLabel()==1 then
		local tc=Duel.GetFirstTarget()
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
