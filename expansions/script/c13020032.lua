--阅后即焚
local s,id,o=GetID()
function s.initial_effect(c)
    aux.AddCodeList(c,13020040)
    --SearchCard
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
    --negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE+CATEGORY_RELEASE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_HAND)
    e3:SetCondition(s.discon)
    e3:SetCost(s.htgcost)
	e3:SetTarget(s.distg)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)
end
function s.filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function s.rlfi2ter(c)
	return c:IsReleasableByEffect()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
        local tc=g:GetFirst()
		if tc:IsLocation(0x02) then
            Duel.ConfirmCards(1-tp,tc)
            Duel.ShuffleHand(tp)
            Duel.BreakEffect()
            local g1=Duel.GetMatchingGroup(s.rlfi2ter,tp,0x04,0,nil)
            local g2=Duel.GetMatchingGroup(s.rlfi2ter,1-tp,0x04,0,nil)
            local rg=Group.CreateGroup()
            if #g1>0 then
                Duel.Hint(3,tp,500)
                local sg=g1:Select(tp,1,1,nil)
                Duel.HintSelection(sg)
                rg:Merge(sg)
            end
            if #g2>0 then
                Duel.Hint(3,tp,500)
                local sg=g2:Select(1-tp,1,1,nil)
                Duel.HintSelection(sg)
                rg:Merge(sg)
            end
            if #rg>0 then Duel.Release(rg,0x40) end
        end
	end
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
        and Duel.IsChainNegatable(ev) and rp==1-tp
        and Duel.GetTurnPlayer()==tp
end
function s.htgcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
    c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,66)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function s.ckfi1ter(c) 
	return c:GetSequence()==0
end
function s.rfilter(c)
    return c:IsType(TYPE_RITUAL)
        and (c:IsType(TYPE_MONSTER) or c:IsType(TYPE_SPELL))
end
function s.CheckRel(c,tp)
    if c:IsReleasableByEffect(c) then return true end
    if Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE) and c:IsType(TYPE_TRAP+TYPE_SPELL) then
        local re={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)}
        for i,v in ipairs(re) do
            if val(v,c) then
                return false
            end
        end
    end
    return true
end
function s.sfi1ter(c,e,tp) 
	return s.rfilter(c) and (s.CheckRel(c,tp) or c:IsDestructable(e))
end
function s.sfi2ter(c,tp) 
	return s.CheckRel(c,tp) and s.rfilter(c)
end
function s.sfi3ter(c,e) 
	return c:IsDestructable(e) and s.rfilter(c)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.ckfi1ter,tp,0x01,0,nil)
    local NgCheck=false
    if #g>0 then
        local tc=g:GetFirst()
        Duel.MoveSequence(tc,SEQ_DECKTOP)
        Duel.ConfirmDecktop(tp,2)
        local hg=Duel.GetFieldGroup(tp,0x02,0)
        local dg=Duel.GetDecktopGroup(tp,2)
        dg:Merge(hg)
        local cg=dg:Filter(s.sfi1ter,nil,e,tp)
        local rcg=dg:Filter(s.sfi2ter,nil)
        local dcg=dg:Filter(s.sfi3ter,nil,e)
        local erg=Group.CreateGroup()
        local edg=Group.CreateGroup()
        if #cg>=3 then
            if #rcg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
                local min=3-#dcg
                if min<1 then min=1 end
                local max=#rcg
                if max>3 then max=3 end
                Duel.Hint(3,tp,500)
                erg=rcg:Select(tp,min,max,nil)
            end
            if #erg<=3 and (#erg~=0 or (#dcg>=3 and Duel.SelectYesNo(tp,aux.Stringid(id,1)))) then
                local val=3-#erg
                Duel.Hint(3,tp,502)
                edg=dcg:Select(tp,val,val,nil)
            end
        end
        if tc:IsLocation(0x01) then
            Duel.MoveSequence(tc,SEQ_DECKBOTTOM)
        end
        if #edg+#erg==3 then
            Duel.DisableShuffleCheck()
            local dv=Duel.SendtoGrave(erg,0x42)
            Duel.DisableShuffleCheck()
            local dr=Duel.Destroy(edg,0x40)
            if dv+dr==3 then NgCheck=true end
        end
    end
	if NgCheck and Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end