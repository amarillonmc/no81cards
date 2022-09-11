--自然妖精·蒲公英
function c3679215.initial_effect(c)
	--
	if c:GetOriginalCode()==3679215 then

	--link summon
	aux.AddLinkProcedure(c,c3679215.matfilter,1,1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3679215,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,3679215)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c3679215.thtg)
	e1:SetOperation(c3679215.thop)
	c:RegisterEffect(e1)
	--adjust
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCode(EVENT_ADJUST)
	e01:SetRange(0xff)
	e01:SetOperation(c3679215.adjustop)
	c:RegisterEffect(e01)
	--change effect type
	local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_FIELD)
	e02:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e02:SetCode(3679215)
	e02:SetRange(LOCATION_MZONE)
	e02:SetTargetRange(1,0)
	c:RegisterEffect(e02)

	end
end
function c3679215.matfilter(c)
	return c:IsLinkSetCard(0x2a) and not c:IsLinkType(TYPE_LINK)
end
function c3679215.thfilter(c)
	return c:IsSetCard(0x2a) and c:IsAbleToHand()
end
function c3679215.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3679215.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c3679215.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c3679215.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c3679215.filter(c)
	return c:IsSetCard(0x2a) and not c:IsCode(3679215) and c:IsType(TYPE_MONSTER)
end
function c3679215.actarget(e,te,tp)
	--prevent activating
	local tc=te:GetHandler()
	return te:GetValue()==3679215 and tc:IsLocation(LOCATION_HAND) and not Duel.IsPlayerAffectedByEffect(te:GetHandlerPlayer(),3679215)
end
function c3679215.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not c3679215.globle_check then
		c3679215.globle_check=true
		local ge0=Effect.CreateEffect(e:GetHandler())
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetCode(EFFECT_ACTIVATE_COST)
		ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetCost(aux.FALSE)
		ge0:SetTargetRange(1,1)
		ge0:SetTarget(c3679215.actarget)
		Duel.RegisterEffect(ge0,0)
		local g=Duel.GetMatchingGroup(c3679215.filter,0,0xff,0xff,nil)
		cregister=Card.RegisterEffect
		esetrange=Effect.SetRange
		table_effect={}
		table_range={}
		Effect.SetRange=function(effect,range)
			table_range[effect]=range
			return esetrange(effect,range)
			end
		c3679215.GetRange=function(effect)
			if table_range[effect] then 
				return table_range[effect]
			end
			return nil
			end
		--for i,f in pairs(Effect) do Debug.Message(i) end
		Card.RegisterEffect=function(card,effect,flag)
			if effect then
				local eff=effect:Clone()
				if c3679215.GetRange(effect)==LOCATION_MZONE and (effect:IsHasType(EFFECT_TYPE_QUICK_O) or effect:IsHasType(EFFECT_TYPE_TRIGGER_O) or effect:IsHasType(EFFECT_TYPE_TRIGGER_F) or effect:IsHasType(EFFECT_TYPE_IGNITION)) then
					eff:SetValue(3679215)
					esetrange(eff,LOCATION_HAND+LOCATION_MZONE)
				end
				table.insert(table_effect,eff)
			end
			return 
		end
		for tc in aux.Next(g) do
			table_effect={}
			tc:ReplaceEffect(3679215,0)
			Duel.CreateToken(0,tc:GetOriginalCode())
			for key,eff in ipairs(table_effect) do
				cregister(tc,eff)
			end
		end
		Card.RegisterEffect=cregister
		Effect.SetRange=esetrange
	end
	e:Reset()
end
