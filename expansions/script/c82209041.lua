local m=82209041
local cm=_G["c"..m]
function cm.initial_effect(c)
	--enable type  
	aux.EnablePendulumAttribute(c)
	aux.EnableDualAttribute(c)  
	--splimit  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_FIELD)  
	e0:SetRange(LOCATION_PZONE)  
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)  
	e0:SetTargetRange(1,0)  
	e0:SetTarget(cm.splimit)  
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(cm.thcon2)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+10000)
	e3:SetCondition(cm.negcon)
	e3:SetTarget(cm.negtg)
	e3:SetOperation(cm.negop)
	c:RegisterEffect(e3)
	--cannot be fusion material  
	local e9=Effect.CreateEffect(c)  
	e9:SetType(EFFECT_TYPE_SINGLE)  
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e9:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)  
	e9:SetValue(1)  
	c:RegisterEffect(e9)
end
cm.SetCard_01_Kieju=true 
function cm.isKieju(code)
	local ccode=_G["c"..code]
	return ccode.SetCard_01_Kieju
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp)  
	if cm.isKieju(c:GetCode()) then return false end  
	return c:IsLocation(LOCATION_DECK) or c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE)
end
function cm.thconfilter(c,tp)  
	return (c:GetSummonPlayer()==tp and c:GetSummonType()==SUMMON_TYPE_PENDULUM and cm.isKieju(c:GetCode()) and c:IsFaceup()) or c:GetSummonPlayer()==1-tp
end  
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(cm.thconfilter,1,nil,tp)  
end  
function cm.thconfilter2(c,tp)  
	return c:GetSummonPlayer()==1-tp
end  
function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(cm.thconfilter2,1,nil,tp)  
end  
function cm.thfilter(c)  
	return cm.isKieju(c:GetCode()) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsLevel(7) 
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
	local sg=Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,e:GetHandler())
	if sg:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0) 
	end 
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then  
		Duel.ConfirmCards(1-tp,g)  
		local sg=Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,e:GetHandler())
		if sg:GetCount()>0 then
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end   
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return c:IsDualState() and not c:IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and ((rp==tp and cm.isKieju(rc:GetCode()) and rc:IsType(TYPE_PENDULUM)) or rp==1-tp)
end  
function cm.negfilter(c,tp)  
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and cm.isKieju(c:GetCode()) and not c:IsForbidden() and c:CheckUniqueOnField(tp)  
end  
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0  
		and Duel.IsExistingMatchingCard(cm.negfilter,tp,LOCATION_DECK,0,1,nil,tp) end  
end  
function cm.negop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)  
	local tc=Duel.SelectMatchingCard(tp,cm.negfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()  
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then  
		Duel.NegateActivation(ev) 
	end  
end  