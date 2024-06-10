--隐匿之徒背信之举
local s,id,o=GetID()
function c29415136.initial_effect(c)
	--sp 
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_SINGLE) 
	e0:SetCode(29415126)  
	e0:SetRange(LOCATION_DECK)  
	e0:SetOperation(s.spop) 
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
--special
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerCanSpecialSummonMonster(tp,id,0x980,TYPE_NORMAL+TYPE_MONSTER,0,0,3,RACE_FIEND,ATTRIBUTE_DARK) and Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,1)) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP) 
	end
end
--
function s.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end 
end 
function s.special(c,e,tp)
    return c:IsSetCard(0x980) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.hand(c)
    return c:IsSetCard(0x980) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(s.hand,tp,LOCATION_DECK,0,nil)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then 
		local tc=Duel.GetFieldCard(tp,LOCATION_DECK,0)
		Duel.ConfirmCards(tp,tc) 
		Duel.ConfirmCards(1-tp,tc)  
		local xtype=0 
		if tc:IsType(TYPE_MONSTER) then xtype=bit.bor(xtype,TYPE_MONSTER) end 
		if tc:IsType(TYPE_SPELL) then xtype=bit.bor(xtype,TYPE_SPELL) end 
		if tc:IsType(TYPE_TRAP) then xtype=bit.bor(xtype,TYPE_TRAP) end 
		if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,xtype) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
			local rg=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,xtype):GetFirst()
            if rg:IsType(TYPE_MONSTER) then
                local ctp=rg:GetControler()
                Duel.GetControl(rg,1-ctp)
                if c:GetControler()==ctp and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
                    local ag=g:Select(tp,1,1,nil):GetFirst()
                    if  Duel.SendtoHand(ag,nil,REASON_EFFECT) and ag:IsType(TYPE_MONSTER) and ag:IsCanBeSpecialSummoned(e,0,tp,false,false)
                        and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
                        Duel.SpecialSummon(ag,0,tp,tp,false,false,POS_FACEUP)
                    end
                end
            else
                if Duel.Destroy(rg,REASON_EFFECT)~=0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
                    Duel.SSet(tp,rg)
                end
            end
		end 
	end   
end
