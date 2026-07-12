--「凡类」的「藤冠」
local s,id,o=GetID()
function s.initial_effect(c)
	--发动
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_REMOVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	--手卡发动
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end
function s.confilter(c,tpye)
	local b1=c:IsLocation(LOCATION_MZONE) and c:IsType(tpye)
    local b2=c:IsLocation(LOCATION_SZONE) and c:GetOriginalType()&tpye>0 and c:GetOriginalType()&TYPE_MONSTER>0
	return c:IsFaceup() and (b1 or b2)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.confilter,tp,0,LOCATION_ONFIELD,1,nil,TYPE_RITUAL)
    local b2=Duel.IsExistingMatchingCard(s.confilter,tp,0,LOCATION_ONFIELD,1,nil,TYPE_FUSION)
    local b3=Duel.IsExistingMatchingCard(s.confilter,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SYNCHRO)
    local b4=Duel.IsExistingMatchingCard(s.confilter,tp,0,LOCATION_ONFIELD,1,nil,TYPE_XYZ)
	if chk==0 then return (b1 or b2 or b3 or b4) end
    local off=1
	local ops={}
	local opval={}
    if b1 then
		ops[off]=aux.Stringid(id,3)
		opval[off-1]=TYPE_RITUAL
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,4)
		opval[off-1]=TYPE_FUSION
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(id,5)
		opval[off-1]=TYPE_SYNCHRO
		off=off+1
	end    
    if b4 then
		ops[off]=aux.Stringid(id,6)
		opval[off-1]=TYPE_XYZ
		off=off+1
	end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local op=Duel.SelectOption(tp,table.unpack(ops))
    e:SetLabel(opval[op])    
end
function s.posfilter(c,tpye)
	return c:IsFaceup() and c:IsType(tpye) and c:IsCanChangePosition()
end    
function s.rmfilter(c,tp,tpye)	
	local b1=c:IsLocation(LOCATION_MZONE) and c:IsType(tpye)
    local b2=c:IsLocation(LOCATION_SZONE) and c:GetOriginalType()&tpye>0 and c:GetOriginalType()&TYPE_MONSTER>0
	return c:IsFaceup() and c:IsAbleToRemove(tp,POS_FACEDOWN) and (b1 or b2)
end    
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local type=e:GetLabel()
    local g=Duel.GetMatchingGroup(s.posfilter,tp,0,LOCATION_MZONE,nil,type)
    if g:GetCount()>=2 and Duel.SelectYesNo(1-tp,aux.Stringid(id,2)) then
    	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_POSCHANGE)
		local pg=Duel.SelectMatchingCard(1-tp,s.posfilter,1-tp,LOCATION_MZONE,0,2,g:GetCount(),nil,type)
        Duel.HintSelection(pg)
        Duel.ChangePosition(pg,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
    else
    	local rg=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_ONFIELD,nil,tp,type)
        if rg:GetCount()>0 and Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)~=0 then
        	local oc=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
            if oc>0 then
            	Duel.Draw(tp,oc,REASON_EFFECT)            
            end
        end
    end
end
function s.cfilter1(c)
	return c:GetSequence()>4
end
function s.cfilter2(c)
	return c:GetSequence()<5
end    
function s.cfilter3(c)
	return c:GetSequence()<5 and c:GetOriginalType()&TYPE_MONSTER>0 
end
function s.handcon(e)
	local exc=Duel.IsExistingMatchingCard(s.cfilter1,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
    local mzc=Duel.IsExistingMatchingCard(s.cfilter2,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
    local szc=Duel.IsExistingMatchingCard(s.cfilter3,e:GetHandlerPlayer(),0,LOCATION_SZONE,1,nil)
	return ((exc and mzc) or (exc and szc) or (mzc and szc))
end