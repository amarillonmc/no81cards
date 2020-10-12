local m=15000245
local cm=_G["c"..m]
cm.name="希望：永寂之国"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)
	--double damage  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)  
	e2:SetCondition(cm.dbcon)  
	e2:SetTarget(cm.dbtg)  
	e2:SetOperation(cm.dbop)  
	c:RegisterEffect(e2)
end
function cm.spfilter(c)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0xf37)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_SPSUMMON_PROC)  
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)  
	e1:SetRange(LOCATION_GRAVE)  
	e1:SetCondition(cm.linkcon)  
	e1:SetOperation(cm.linkop)  
	e1:SetValue(SUMMON_TYPE_LINK)
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)  
	e2:SetRange(LOCATION_FZONE)  
	e2:SetTargetRange(LOCATION_GRAVE,0)  
	e2:SetTarget(cm.mattg) 
	e2:SetReset(RESET_PHASE+PHASE_END) 
	e2:SetLabelObject(e1)  
	Duel.RegisterEffect(e2,tp)  
end
function cm.mattg(e,c)  
	return c:IsSetCard(0xf37) and c:IsType(TYPE_LINK)  
end
function cm.lmfilter(c,lc,tp)  
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_LMATERIAL) and Duel.GetLocationCountFromEx(tp,tp,c,lc)>0 and c:IsType(TYPE_EFFECT)
end  
function cm.lmfilter2(c,lc,tp)  
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_LMATERIAL) and Duel.GetLocationCountFromEx(tp,tp,c,lc)>0 and c:IsSetCard(0xf37) and not c:IsCode(15000255)
end
function cm.linkcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()  
	local x=114514
	if c:IsLink(1) then x=1 end
	if c:IsLink(2) then x=2 end
	return ((x==1 and Duel.IsExistingMatchingCard(cm.lmfilter2,tp,LOCATION_MZONE,0,1,nil,c,tp)) or (x==2) and Duel.IsExistingMatchingCard(cm.lmfilter,tp,LOCATION_MZONE,0,2,nil,c,tp)) and Duel.GetFlagEffect(tp,c:GetCode())==0
end  
function cm.linkop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()  
	local mg=Group.CreateGroup()
	if c:IsLink(1) then
		mg=Duel.SelectMatchingCard(tp,cm.lmfilter2,tp,LOCATION_MZONE,0,1,1,nil,c,tp)
	end
	if c:IsLink(2) then
		mg=Duel.SelectMatchingCard(tp,cm.lmfilter,tp,LOCATION_MZONE,0,2,2,nil,c,tp)
	end  
	c:SetMaterial(mg)  
	Duel.SendtoGrave(mg,REASON_MATERIAL+REASON_LINK)  
	Duel.RegisterFlagEffect(tp,c:GetCode(),RESET_PHASE+PHASE_END,0,1)
end
function cm.dbcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsAbleToEnterBP()  
end  
function cm.dbfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0xf37) and c:GetSummonLocation()==LOCATION_EXTRA and c:GetFlagEffect(m)==0  
end  
function cm.dbtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.dbfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.dbfilter,tp,LOCATION_MZONE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)  
	Duel.SelectTarget(tp,cm.dbfilter,tp,LOCATION_MZONE,0,1,1,nil)  
end  
function cm.dbop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)  
		e1:SetCondition(cm.damcon)  
		e1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e1)  
	end  
end  
function cm.damcon(e)  
	return e:GetHandler():GetBattleTarget()~=nil  
end