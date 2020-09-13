local m=72100039
local cm=_G["c"..m]
cm.name="淘气仙星·月光舞姬"
function cm.initial_effect(c)
	c:SetSPSummonOnce(m) 
	--link summon  
	aux.AddLinkProcedure(c,nil,2,99,cm.lcheck)  
	c:EnableReviveLimit() 
	--mat check  
	local e11=Effect.CreateEffect(c)  
	e11:SetType(EFFECT_TYPE_SINGLE)  
	e11:SetCode(EFFECT_MATERIAL_CHECK)  
	e11:SetValue(cm.matcheck1)  
	c:RegisterEffect(e11)  
	local e12=e11:Clone(c)
	e12:SetValue(cm.matcheck2)
	c:RegisterEffect(e12)
	local e13=e11:Clone(c)
	e13:SetValue(cm.matcheck3)
	c:RegisterEffect(e13)
	local e14=e11:Clone(c)
	e14:SetValue(cm.matcheck4)
	c:RegisterEffect(e14)
	--burn
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EVENT_TO_GRAVE)  
	e2:SetRange(LOCATION_MZONE) 
	e2:SetLabelObject(e11)
	e2:SetCondition(cm.matcon)
	e2:SetOperation(cm.burnop)  
	c:RegisterEffect(e2)
	--atk  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e3:SetCode(EFFECT_UPDATE_ATTACK)  
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabelObject(e12)
	e3:SetCondition(cm.matcon)  
	e3:SetValue(cm.atkval)  
	c:RegisterEffect(e3)	 
	--atk up  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(1122)  
	e4:SetCategory(CATEGORY_DAMAGE)  
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e4:SetProperty(EFFECT_FLAG_DELAY)  
	e4:SetLabelObject(e13)
	e4:SetCondition(cm.matcon2)  
	e4:SetCost(cm.damcost)
	e4:SetTarget(cm.damtg)  
	e4:SetOperation(cm.damop)  
	c:RegisterEffect(e4)  
	--Multiple attacks  
	local e5=Effect.CreateEffect(c)  
	e5:SetDescription(1115)  
	e5:SetType(EFFECT_TYPE_IGNITION)  
	e5:SetCountLimit(1)  
	e5:SetRange(LOCATION_MZONE)  
	e5:SetLabelObject(e14)
	e5:SetCondition(cm.matcon3)  
	e5:SetOperation(cm.atkop)  
	c:RegisterEffect(e5)  
end
function cm.matcheck1(e,c)  
	local g=c:GetMaterial()  
	e:SetLabel(0)  
	if g:IsExists(Card.IsLinkSetCard,1,nil,0xfb) then  
		e:SetLabel(1)  
	end  
end  
function cm.matcheck2(e,c)  
	local g=c:GetMaterial()  
	e:SetLabel(0)  
	if g:IsExists(Card.IsLinkSetCard,1,nil,0xdf) then  
		e:SetLabel(1)  
	end  
end  
function cm.matcheck3(e,c)  
	local g=c:GetMaterial()  
	e:SetLabel(0)  
	if g:IsExists(Card.IsLinkType,1,nil,TYPE_LINK) then  
		e:SetLabel(1)  
	end  
end  
function cm.matcheck4(e,c)  
	local g=c:GetMaterial()  
	e:SetLabel(0)  
	if g:IsExists(Card.IsLinkType,1,nil,TYPE_FUSION) then  
		e:SetLabel(1)  
	end  
end  
function cm.matcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetLabelObject():GetLabel()==1  
end  
function cm.lcheck(g,lc)  
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()  
end  
function cm.cfilter(c,tp)  
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsControler(1-tp) and c:IsType(TYPE_MONSTER) 
end  
function cm.burnop(e,tp,eg,ep,ev,re,r,rp)  
	local ct=eg:FilterCount(cm.cfilter,nil,tp)  
	if ct>0 then  
		Duel.Damage(1-tp,ct*200,REASON_EFFECT)
	end  
end  
function cm.atkval(e,c)  
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_ONFIELD)*200  
end  
function cm.matcon2(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetLabelObject():GetLabel()==1 and e:GetHandler():IsSummonType(TYPE_LINK)
end  
function cm.damfilter(c)
	return c:IsDiscardable(REASON_COST) and c:IsLevelAbove(1)
end
function cm.damcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.damfilter,tp,LOCATION_HAND,0,1,nil) end  
	local g=Duel.SelectMatchingCard(tp,cm.damfilter,tp,LOCATION_HAND,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetOriginalLevel()*200)  
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)  
end  
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetTargetPlayer(1-tp)  
	Duel.SetTargetParam(e:GetLabel())  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel())  
	e:SetLabel(0)  
end  
function cm.damop(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Damage(p,d,REASON_EFFECT)  
end  
function cm.matcon3(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetLabelObject():GetLabel()==1 and Duel.IsAbleToEnterBP()  
end  
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)  
	e1:SetTargetRange(0,LOCATION_MZONE)  
	e1:SetValue(cm.indct)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)  
	if c:IsRelateToEffect(e) then  
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetCode(EFFECT_ATTACK_ALL)  
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		e2:SetValue(2)  
		c:RegisterEffect(e2)  
	end  
end  
function cm.indct(e,re,r,rp)  
	if bit.band(r,REASON_BATTLE)~=0 then  
		return 1  
	else return 0 end  
end  