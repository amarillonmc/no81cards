--有罪与无罪
local s,id,o=GetID()
function s.initial_effect(c)
	--发动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.eftg)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)
	--适用效果
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
    e2:SetCondition(s.thcon)
    e2:SetCost(s.thcost)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		s[0]={}
		s[1]={}
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetOperation(s.regop)
		Duel.RegisterEffect(ge2,0)	
	end
end
function s.codefilter(c,code)
	return c:IsCode(code)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re and re:GetHandlerPlayer() and re:IsActiveType(TYPE_MONSTER) then
        local cg=Duel.GetMatchingGroup(s.codefilter,re:GetHandlerPlayer(),0xff,0xff,nil,re:GetHandler():GetCode())
        for tc in aux.Next(cg) do
        	tc:RegisterFlagEffect(id,RESET_PHASE+PHASE_END,0,1) 
        end
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)	
	for tc in aux.Next(eg) do
    	if tc:IsSetCard(0x67b0) and tc:IsType(TYPE_FUSION) then
			local code=tc:GetCode()
			if Duel.GetFlagEffect(tc:GetSummonPlayer(),id)>0 then return end
			e:SetLabel(0)
			for _,fcode in ipairs(s[tc:GetSummonPlayer()]) do
				if fcode==code then
					e:SetLabel(100)
				end
			end
			if e:GetLabel()==0 then table.insert(s[tc:GetSummonPlayer()],code) end
			if #s[tc:GetSummonPlayer()]>=3 then 
				Duel.RegisterFlagEffect(tc:GetSummonPlayer(),id,0,0,0)
            end
		end
	end
end
function s.tgfilter(c)
	return c:IsSetCard(0x67b0) and c:IsType(TYPE_MONSTER)
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if not tc then return end
	if tc:IsFacedown() then Duel.ConfirmCards(1-tp,tc)
	else Duel.HintSelection(Group.FromCards(tc)) end
    if tc:IsLocation(LOCATION_HAND) then Duel.ShuffleHand(tp) end
    if tc:GetFlagEffect(id)>0 then
    	Duel.Damage(1-tp,800,REASON_EFFECT)    
    else
    	Duel.Draw(tp,1,REASON_EFFECT)
    end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
    Duel.SendtoDeck(c,nil,2,REASON_COST)
    Duel.ConfirmCards(1-tp,c)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCondition(s.bhcon)
	e1:SetOperation(s.bhop)
   	e1:SetCountLimit(1)
	Duel.RegisterEffect(e1,tp)
end
function s.bhfilter(c)
	return c:IsCode(id) and c:IsAbleToHand()
end
function s.bhcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.bhfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
end 
function s.bhop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.bhfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
	end
end