--隐秘的药剂实验室
local m=11631025
local cm=_G["c"..m]
--strings
--
function cm.isYaojishi(card)  
	local code=card:GetCode()
	local ccode=_G["c"..code]
	return ccode.yaojishi
end
function cm.isZhiyaoshu(card)
	local code=card:GetCode()
	local ccode=_G["c"..code]
	return ccode.zhiyaoshu
end
function cm.isTezhiyao(card)
	local code=card:GetCode()
	local ccode=_G["c"..code]
	return ccode.tezhiyao
end


if not cm.actchklist then cm.actchklist={} end
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,m)
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
	--register
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_ACTIVATE_COST)  
	e2:SetRange(LOCATION_HAND)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_UNCOPYABLE)  
	e2:SetTargetRange(1,0)  
	e2:SetTarget(cm.actarget)  
	e2:SetCost(aux.TRUE)  
	e2:SetOperation(cm.costop)  
	c:RegisterEffect(e2) 
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)  
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_UNCOPYABLE) 
	e3:SetRange(LOCATION_FZONE)  
	e3:SetTargetRange(LOCATION_HAND,0)  
	e3:SetTarget(cm.eftg)  
	e3:SetLabelObject(e2)  
	c:RegisterEffect(e3)  
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,m+1)
	e4:SetCondition(cm.con)
	e4:SetTarget(cm.tg)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCondition(cm.con2)
	e5:SetTarget(cm.tg2)
	e5:SetOperation(cm.op2)
	c:RegisterEffect(e5)
end

--activate
function cm.thfilter(c)  
	return c:IsType(TYPE_MONSTER) and cm.isYaojishi(c) and c:IsAbleToHand()  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)  
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
		local sg=g:Select(tp,1,1,nil)  
		Duel.SendtoHand(sg,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,sg)  
	end  
end  

--register
function cm.actarget(e,te,tp)  
	local tc=te:GetHandler()
	return tc==e:GetHandler() and tc:IsLocation(LOCATION_HAND) and tc:IsPublic()
end  
function cm.costop(e,tp,eg,ep,ev,re,r,rp) 
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESET_CHAIN,0,1)
end  
function cm.eftg(e,c)  
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and cm.isTezhiyao(c) and c:IsPublic() 
end  
--destroy
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and cm.isTezhiyao(rc) and rc:GetFlagEffect(m)==0
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and cm.isTezhiyao(rc) and rc:GetFlagEffect(m)>0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,1))
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
end  
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,2))
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp) 
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)  
	if g:GetCount()>0 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
		local sg=g:Select(tp,1,1,nil)  
		Duel.HintSelection(sg)  
		Duel.Destroy(sg,REASON_EFFECT)  
	end  
end  
function cm.op2(e,tp,eg,ep,ev,re,r,rp) 
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)  
	if g:GetCount()>0 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
		local sg=g:Select(tp,1,1,nil)  
		local tc=sg:GetFirst()
		if tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.HintSelection(sg)  
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		else
			Duel.HintSelection(sg)  
			Duel.Destroy(sg,REASON_EFFECT)  
		end
	end  
end  