local m=82228568
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_WATER),3,3,cm.lcheck)  
	c:EnableReviveLimit()   
	--draw  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_DRAW)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetCountLimit(1,m)  
	e1:SetCondition(cm.drcon)
	e1:SetTarget(cm.drtg)  
	e1:SetOperation(cm.drop)  
	c:RegisterEffect(e1)
	--battle indes  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetValue(cm.indes)  
	c:RegisterEffect(e2)
	--indes  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetCondition(cm.indcon)
	e3:SetValue(1)  
	c:RegisterEffect(e3)	
	--atk up  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,1))  
	e4:SetCategory(CATEGORY_ATKCHANGE)  
	e4:SetType(EFFECT_TYPE_QUICK_O)  
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)  
	e4:SetCode(EVENT_FREE_CHAIN)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetCountLimit(1,82218568)  
	e4:SetCondition(cm.atkcon)
	e4:SetCost(cm.atkcost)
	e4:SetOperation(cm.atkop)  
	c:RegisterEffect(e4)  
end  
function cm.lcheck(g)  
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x297)  
end 
function cm.indes(e,c)  
	return e:GetHandler():GetSequence()>4 and c:GetSequence()<=4  
end  
function cm.indcon(e)  
	return e:GetHandler():GetSequence()>4 
end 
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)  
end  
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(1)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end  
function cm.drop(e,tp,eg,ep,ev,re,r,rp,chk)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Draw(p,d,REASON_EFFECT)  
end  
function cm.descon(e,tp,eg,ep,ev,re,r,rp)   
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x297)
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) then 
		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil) 
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
	end
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)  
	if g:GetCount()>0 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
		local sg=g:Select(tp,1,1,nil)  
		Duel.HintSelection(sg)  
		Duel.Destroy(sg,REASON_EFFECT)  
	end  
end  
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:GetAttack()~=c:GetBaseAttack() and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated())  
end  
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckLPCost(tp,1000) end  
	Duel.PayLPCost(tp,1000)  
end  
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_UPDATE_ATTACK)  
	e1:SetValue(1000)  
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)  
	c:RegisterEffect(e1)  
end  