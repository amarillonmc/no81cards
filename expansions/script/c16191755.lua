--傍死即兴 灵魂调律
local s,id,o=GetID()
function s.initial_effect(c)
	--发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--适用效果
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.eftg)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)
	--连接适配    
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(id)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
    if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkfilter(c,tp)
	return c:IsSetCard(0x33b0) and c:IsReason(REASON_EFFECT) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetOwner()
	if eg:IsExists(s.checkfilter,1,nil,p) then  
		Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,1)		
	end
end
function s.tgfilter(c)
	return c:IsSetCard(0x33b0) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x33b0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end		
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) 
    	and Duel.IsPlayerCanDraw(tp,1) and (Duel.GetFlagEffect(tp,id+o*2)==0 or not e:IsCostChecked())
    local b2=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and (Duel.GetFlagEffect(tp,id+o)==0 or not e:IsCostChecked())
	if chk==0 then return (b1 or b2) end
    local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1),1},
		{b2,aux.Stringid(id,2),2})
    e:SetLabel(op)    
    if op==1 then
    	if e:IsCostChecked() then
        	e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
    		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
            Duel.RegisterFlagEffect(tp,id+o*2,RESET_PHASE+PHASE_END,0,1)
        end    
    elseif op==2 then    
    	if e:IsCostChecked() then
        	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
    		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
            Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
        end    
    end    
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
    local op=e:GetLabel()
    if op==1 then   
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
        	Duel.HintSelection(g)
			if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
            	Duel.Draw(tp,1,REASON_EFFECT)            
            end
		end    	
    elseif op==2 then
    	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
        	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end        	
    end   
end