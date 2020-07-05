local m=82206026
local cm=_G["c"..m]
cm.name="植占师6-军团"
function cm.initial_effect(c)
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_SPSUMMON_PROC)  
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCondition(cm.spcon)  
	c:RegisterEffect(e1)
	--lv change  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_LVCHANGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.tg)  
	e2:SetOperation(cm.op)  
	c:RegisterEffect(e2)	
end   
function cm.spcon(e,c)
	local tp=e:GetHandler():GetControler()
	return Duel.GetLP(tp)>Duel.GetLP(1-tp)  
end  
function cm.filter(c)  
	return c:IsFaceup() and c:IsSetCard(0x129d) and c:GetLevel()>0  
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)  
	local lv=g:GetFirst():GetLevel()  
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)  
	e:SetLabel(Duel.AnnounceLevel(tp,1,8,lv))  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_CHANGE_LEVEL)  
		e1:SetValue(e:GetLabel())  
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e1)  
	end  
end  
