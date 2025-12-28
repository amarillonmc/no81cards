--思绪 戏仿相欢
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.actcon)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(1190)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(s.excon)
	e3:SetCountLimit(1,id+1)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
function s.sdfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x6f52)
end
function s.actcon(e)
	return not Duel.IsExistingMatchingCard(s.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) 
		and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function s.rmfilter(c)
	return c:IsSetCard(0x6f52) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if e:GetHandler():IsLocation(LOCATION_SZONE) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then 
			e:SetLabel(1) 
		else 
			e:SetLabel(0) 
		end
		return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_TOKEN)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	if #rg==0 then return end
	local tc=rg:GetFirst()
	local code=tc:GetCode()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
		local token=Duel.CreateToken(tp,code)
		if token and Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			Duel.SpecialSummonComplete()
			if e:GetLabel()==1 and Duel.IsPlayerCanDraw(tp,1) 
				and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCode(EFFECT_CANNOT_ACTIVATE)
	e7:SetTargetRange(1,0)
	e7:SetValue(s.aclimit)
	Duel.RegisterEffect(e7,tp)
end
function s.aclimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0x6f52)
end
function s.excon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.sdfilter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0 and Duel.GetTurnPlayer()==tp
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.aclimit)
	Duel.RegisterEffect(e1,tp)
end