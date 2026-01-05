--颶風海劫“幽靈”瑪麗·西萊特斯號
local s,id,o=GetID()
function s.initial_effect(c)
    --SpSum(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
    local e3=e1:Clone()
    e3:SetHintTiming(0,TIMING_END_PHASE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_HAND)
    c:RegisterEffect(e3)
    --SpSum(0x02)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.scon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.thfilter(c)
	return c:IsSetCard(0x540b) and c:IsFaceup()
        and c:IsAbleToHand() and not c:IsLevel(6)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(0x04) and s.filter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.thfilter,tp,0x04,0,1,nil)
        and Duel.GetFlagEffect(tp,id)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,0x04,0,1,1,nil)
    Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,EFFECT_FLAG_OATH,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,0x40)>0 then
            --Atk/Def Up
            local val=tc:GetBaseAttack()
            if val>0 then
                local e1=Effect.CreateEffect(c)
    		    e1:SetType(EFFECT_TYPE_SINGLE)
    		    e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    		    e1:SetValue(val)
    		    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    		    c:RegisterEffect(e1)
                local e2=e1:Clone()
		        e2:SetCode(EFFECT_UPDATE_DEFENSE)
		        c:RegisterEffect(e2)
            end
		end
	end
end
function s.scon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsPreviousPosition(POS_FACEUP)
end
function s.spfi1ter(c,e,tp)
	return c:IsSetCard(0x540b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
        local c=e:GetHandler()
        if c:IsLocation(0x02) and c:GetFlagEffect(id)==0 then
            c:RegisterFlagEffect(id,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
        end
        return Duel.GetLocationCount(tp,0x04)>0 and Duel.GetFlagEffect(tp,id)==0
		    and Duel.IsExistingMatchingCard(s.spfi1ter,tp,0x02,0,1,nil,e,tp)
    end
    Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,EFFECT_FLAG_OATH,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x02)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if Duel.GetLocationCount(tp,0x04)>0 then
	    Duel.Hint(3,tp,509)
	    local g=Duel.SelectMatchingCard(tp,s.spfi1ter,tp,0x02,0,1,1,nil,e,tp)
	    if g:GetCount()>0 then
		    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	    end
    end
end