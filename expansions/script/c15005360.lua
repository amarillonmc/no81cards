local m=15005360
local cm=_G["c"..m]
cm.name="迷忆渊裔249-死亡的血泪"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xcf3c),3,2)
	c:EnableReviveLimit()
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	--cannot disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_INACTIVATE)
	e3:SetLabel(3)
	e3:SetValue(cm.effectfilter)
	e3:SetCondition(cm.effectcon)
	Duel.RegisterEffect(e3,0)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	e4:SetLabel(4)
	Duel.RegisterEffect(e4,0)
	e3:SetLabelObject(e4)
	e4:SetLabelObject(c)
end
function cm.effectcon(e)
	return e:GetHandler():GetOverlayCount()==0
end
function cm.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local label=e:GetLabel()
	local tc
	if label==3 then
		tc=e:GetLabelObject():GetLabelObject()
	else
		tc=e:GetLabelObject()
	end
	return tc and tc==te:GetHandler()
end
function cm.filter(c,e,tp,g)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_HAND) and g:IsContains(c) and ((Duel.GetFlagEffect(tp,15005360)==0 and Duel.IsPlayerCanDraw(tp,1)) or (Duel.GetFlagEffect(tp,15005361)==0 and c:IsCanOverlay()))
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and cm.filter(chkc,e,tp,eg) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp,eg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,eg)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local b1=Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetFlagEffect(tp,15005360)==0
	local b2=tc:IsCanOverlay() and tc:IsRelateToEffect(e) and c:IsRelateToEffect(e)
		and Duel.GetFlagEffect(tp,15005361)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(m,2))+1
	else return end
	if op==0 then
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,15005360,RESET_PHASE+PHASE_END,0,1)
	else
		if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
			local og=tc:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
			Duel.Overlay(c,tc)
		end
		Duel.RegisterFlagEffect(tp,15005361,RESET_PHASE+PHASE_END,0,1)
	end
end