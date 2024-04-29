--次元的崩坏
function c11560312.initial_effect(c)
	c:SetUniqueOnField(1,0,11560312) 
	--redirect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e0)   
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	--e1:SetCountLimit(1,11560310+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(c11560312.actg) 
	e1:SetOperation(c11560312.acop) 
	c:RegisterEffect(e1) 
	--Negate 
	--local e2=Effect.CreateEffect(c)
	--e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	--e2:SetDescription(aux.Stringid(11560312,0))
	--e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	--e2:SetType(EFFECT_TYPE_QUICK_O)
	--e2:SetCode(EVENT_CHAINING)
	--e2:SetRange(LOCATION_SZONE)
	--e2:SetCondition(c11560312.discon)
	--e2:SetTarget(c11560312.distg)
	--e2:SetOperation(c11560312.disop)
	--c:RegisterEffect(e2) 

	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCountLimit(1) 
	e2:SetCost(c11560312.spcost)   
	e2:SetTarget(c11560312.sptg) 
	e2:SetOperation(c11560312.spop) 
	c:RegisterEffect(e2) 
	--to deck and draw  
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetRange(LOCATION_REMOVED) 
	e3:SetCountLimit(1,11560312)
	e3:SetCost(c11560312.stcost) 
	e3:SetTarget(c11560312.sttg) 
	e3:SetOperation(c11560312.stop) 
	c:RegisterEffect(e3)
end
c11560312.SetCard_XdMcy=true 
function c11560312.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,LOCATION_GRAVE)  
	if chk==0 then return g:GetCount()==g:FilterCount(Card.IsAbleToRemove,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end 
function c11560312.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,LOCATION_GRAVE)  
	if g:GetCount()==g:FilterCount(Card.IsAbleToRemove,nil) then 
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT) 
	--if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11560312,0)) then 
	--local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,g:GetCount(),nil)
	--Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	--end 
	local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil) 
	local x=Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)
	if ag:GetCount()>0 and x>0 then  
	Duel.BreakEffect() 
	local tc=ag:GetFirst() 
	while tc do 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(-x*100) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	tc:RegisterEffect(e1) 
	tc=ag:GetNext() 
	end 
	end 
	end 
end 
function c11560312.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function c11560312.distg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end  
function c11560312.drmfil(c,xtype) 
	return c:IsType(xtype) and c:IsAbleToRemove() 
end 
function c11560312.disop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local x=Duel.AnnounceType(1-tp) 
	local xtype=0 
	if x==0 then xtype=TYPE_MONSTER end 
	if x==1 then xtype=TYPE_SPELL end 
	if x==2 then xtype=TYPE_TRAP end 
	if Duel.IsExistingMatchingCard(c11560312.drmfil,tp,LOCATION_HAND,0,1,nil,xtype) and Duel.SelectYesNo(tp,aux.Stringid(11560312,1)) then 
	local sg=Duel.SelectMatchingCard(tp,c11560312.drmfil,tp,LOCATION_HAND,0,1,1,nil,xtype) 
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then 
	Duel.Destroy(eg,REASON_EFFECT) 
	end  
	end 
end 
function c11560312.stcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end 
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST) 
end   
function c11560312.xgck(g)  
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)==1 
	   and g:FilterCount(Card.IsType,nil,TYPE_SPELL)==1 
	   and g:FilterCount(Card.IsType,nil,TYPE_TRAP)==1
end 
function c11560312.sttg(e,tp,eg,ep,ev,re,r,rp,chk)   
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,e:GetHandler())
	if chk==0 then return g:CheckSubGroup(c11560312.xgck,3,3) and Duel.IsPlayerCanDraw(tp,2) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end 
function c11560312.stop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,nil)
	if g:CheckSubGroup(c11560312.xgck,3,3) then 
		local sg=g:SelectSubGroup(tp,c11560312.xgck,false,3,3) 
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT) 
		if Duel.IsPlayerCanDraw(tp,2) then 
			Duel.Draw(tp,2,REASON_EFFECT)
		end 
	end 
end 
function c11560312.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil) 
	Duel.Remove(g,POS_FACEUP,REASON_COST) 
end  
function c11560312.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c.SetCard_XdMcy  
end 
function c11560312.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c11560312.spfil,tp,LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED) 
end 
function c11560312.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11560312.spfil,tp,LOCATION_REMOVED,0,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 
