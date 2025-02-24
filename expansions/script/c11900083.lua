--死者的归所
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,11900061)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.actg)
	e1:SetOperation(s.acop)
	c:RegisterEffect(e1) 
	--to grave and draw 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,id)
	e2:SetCondition(function(e) 
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) end)
	e2:SetCost(s.tgdcost) 
	e2:SetTarget(s.tgdtg) 
	e2:SetOperation(s.tgdop) 
	c:RegisterEffect(e2) 
end 
function s.rlfi1ter(c,sc) 
	return c:IsReleasable() and c:IsDefenseAbove(1) and c:IsCanBeRitualMaterial(sc)
end  
function s.rlgck(g,sc,tp)  
	Duel.SetSelectedCard(g) 
	return g:CheckWithSumGreater(Card.GetDefense,sc:GetBaseAttack()) and Duel.GetMZoneCount(tp,g)>0 
end 
function s.rspfi1ter(c,e,tp)
    local val=Duel.GetMatchingGroup(s.rlfi1ter,c:GetControler(),LOCATION_HAND+LOCATION_MZONE,0,c,c):GetSum(Card.GetDefense)
	return c:IsType(TYPE_RITUAL) and aux.IsCodeListed(c,11900061) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
        and c:GetBaseAttack()<=val
end 
function s.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rspfi1ter,tp,LOCATION_DECK,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end 
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(s.rspfi1ter,tp,LOCATION_DECK,0,nil,e,tp) 
	if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		local mg=Duel.GetMatchingGroup(s.rlfi1ter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,tc)
        local ng=Group.CreateGroup()
        ng:Merge(mg)
        local Tdef=0
        local pg=Group.CreateGroup()
        local mcheck=true
        while #ng>0 and mcheck do
            local cg,def=ng:GetMinGroup(Card.GetDefense)
            Adef=def*#cg
            Tdef=Tdef+Adef
            pg:Merge(cg)
            ng:Sub(cg)
            if Tdef>=tc:GetAttack() then
                mcheck=false
            end
        end
        local gm=#pg
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectSubGroup(tp,s.rlgck,false,1,gm,tc,tp)
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		if Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP) then
            local e1=Effect.CreateEffect(e:GetHandler())
		    e1:SetType(EFFECT_TYPE_SINGLE)
		    e1:SetCode(EFFECT_DISABLE)
		    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		    tc:RegisterEffect(e1)
		    local e2=Effect.CreateEffect(e:GetHandler())
		    e2:SetType(EFFECT_TYPE_SINGLE)
		    e2:SetCode(EFFECT_DISABLE_EFFECT)
		    e2:SetValue(RESET_TURN_SET)
		    e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		    tc:RegisterEffect(e2)
            Duel.SpecialSummonComplete()
            tc:CompleteProcedure()
            Duel.BreakEffect()
		    Duel.SendtoGrave(tc,REASON_EFFECT)
        end
	end
end 
function s.tgdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsAbleToGraveAsCost() and (c:IsCode(11900061) or aux.IsCodeListed(c,11900061)) end,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsAbleToGraveAsCost() and (c:IsCode(11900061) or aux.IsCodeListed(c,11900061)) end,tp,LOCATION_HAND,0,1,1,nil) 
	Duel.SendtoGrave(g,REASON_COST) 
end 
function s.tgdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end 
	Duel.SetTargetPlayer(tp) 
	Duel.SetTargetParam(1) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end 
function s.tgdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT) 
end