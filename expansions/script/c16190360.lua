--噗啾噗姆★短耳绒
local s,id,o=GetID()
function s.initial_effect(c)
	--补充超量素材
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCondition(s.mtcon)
	e1:SetTarget(s.mttg)
	e1:SetOperation(s.mtop)
	c:RegisterEffect(e1)
	--墓地回收
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_MOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)        
end
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.xyzfilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_ILLUSION) and c:IsType(TYPE_XYZ) and c:IsRank(2)
    	and Duel.IsExistingMatchingCard(s.mtfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c,e)
end
function s.mtfilter(c,e)
	return (c:IsLevel(2) or c:IsRank(2) or c:IsLink(2)) and c:IsRace(RACE_ILLUSION) and c:IsCanOverlay() 
    	and not (e and c:IsImmuneToEffect(e))
end
function s.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
		and e:GetHandler():IsCanOverlay() and Duel.IsPlayerCanDraw(tp,1) end    
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
    local dg=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectMatchingCard(tp,s.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.HintSelection(g)
	local xc=g:GetFirst()
    dg:AddCard(c)
    dg:AddCard(xc)
    local mg=Duel.GetMatchingGroup(s.mtfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,dg,e)
    local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local xg=mg:Select(tp,1,ct-1,dg)
    Duel.HintSelection(xg)
    xg:AddCard(c)	
    local dt=0
    for oc in aux.Next(xg) do 
		local og=oc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end				
		Duel.Overlay(xc,Group.FromCards(oc))
        local sg=Duel.GetOperatedGroup()   
        dt=dt+sg:GetCount()     
	end
	if dt>0 then
    	Duel.Draw(tp,dt,REASON_EFFECT)
    end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ((c:IsReason(REASON_COST+REASON_EFFECT+REASON_RULE) and re) or c:IsReason(REASON_SUMMON+REASON_SPSUMMON))
    	and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function s.thfilter(c)
	return c:IsSetCard(0xb203) and c:IsType(TYPE_MONSTER) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end