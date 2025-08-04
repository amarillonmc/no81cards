local s,id,o=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
    --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(0x04) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanChangePosition,tp,0x04,0,1,nil) end
	Duel.Hint(3,tp,551)
	local g=Duel.SelectTarget(tp,Card.IsCanChangePosition,tp,0x04,0,1,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsOnField() then
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_CHAIN_END)
        e1:SetLabelObject(tc) 
        e1:SetCountLimit(1)
        e1:SetCondition(s.retcon)
        e1:SetOperation(s.retop)
        e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+EVENT_CHAIN_END) 
        Duel.RegisterEffect(e1,tp)
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(id)~=0
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
    if c:IsOnField() and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
        local pos=0
		if c:IsCanTurnSet() then
			pos=Duel.SelectPosition(tp,c,POS_DEFENSE)
		else
			pos=Duel.SelectPosition(tp,c,POS_FACEUP_ATTACK)
		end
		Duel.ChangePosition(c,pos)
    end
end
function s.fi2ter(c,e,sp,...)
	return c:IsSetCard(0xa14) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
        and not c:IsCode(...)
end
function s.fi1ter(c,e,sp)
	return c:IsSetCard(0xa14) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
        and Duel.GetMatchingGroup(s.rlfi1ter,tp,0x04,0,nil):FilterCount(s.cdfilter,nil,c:GetCode())>0
end
function s.cdfilter(c,code)
    return not c:IsCode(code)
end
function s.filter(c,e,sp)
	return c:IsSetCard(0xa14) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function s.rlfi1ter(c)
    return c:IsFaceup() and c:IsSetCard(0xa14) and c:IsAbleToRemove()
end
function s.sqfi1ter(c)
    return c:GetSequence()>4
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.fi1ter,tp,0x41,0,2,nil,e,tp)
        and Duel.IsExistingMatchingCard(s.rlfi1ter,tp,0x04,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x41)
end
function s.rmfselect(g,e,tp)
	local code={}
	for tc in aux.Next(g) do
		table.insert(code,tc:GetCode())
	end
	local sg=Duel.GetMatchingGroup(s.fi2ter,tp,0x41,0,nil,e,tp,table.unpack(code))
	if sg:GetClassCount(Card.GetCode)>=g:GetCount() and Duel.GetMZoneCount(tp,g)>=g:GetCount() then
		return Duel.CheckReleaseGroup(tp,aux.IsInGroup,#g,nil,g)
	else return false end
end
function s.spfselect(g,tp)
	return g:FilterCount(Card.IsLocation,nil,0x01)<=Duel.GetLocationCount(tp,0x04)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    local dg=Duel.GetMatchingGroup(s.rlfi1ter,tp,0x04,0,nil)
    if #dg>0 then
        local dsv=Duel.GetMatchingGroupCount(s.filter,tp,0x41,0,nil,e,tp)
        local mz=Duel.GetLocationCount(tp,0x04)
        if Duel.GetMatchingGroupCount(s.filter,tp,0x40,0,nil,e,tp)>0 and Duel.GetMatchingGroupCount(s.sqfi1ter,tp,0x04,0,nil)==0 then mz=mz+1 end
        if dsv<2 then mz=0
        elseif dsv<4 and mz>1 then mz=1
        elseif dsv<6 and mz>2 then mz=2
        end
        if mz==0 then return end
        Duel.Hint(3,tp,503)
        local sg=dg:SelectSubGroup(tp,s.rmfselect,false,1,mz,e,tp)
        local code={}
	    for tc in aux.Next(sg) do
		    table.insert(code,tc:GetCode())
	    end
        if Duel.Remove(sg,POS_FACEUP,0x40)>0 then
            local rg=sg:Filter(Card.IsLocation,nil,0x20)
            if #rg>0 then
                local val=#rg*2
	            local spg=Duel.GetMatchingGroup(s.fi2ter,tp,0x41,0,nil,e,tp,table.unpack(code))
                local sc=spg:SelectSubGroup(tp,s.spfselect,false,val,val,tp)
	            if #sc==val then Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) end
            end
        end
    end
end