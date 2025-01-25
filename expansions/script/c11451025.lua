--幽玄龙景＊纪镇一宿
local cm,m=GetID()
function cm.initial_effect(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--spirit return
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(cm.SpiritReturnReg)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SUMMON+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_MOVE)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.sumcon)
	e3:SetTarget(cm.sumtg1)
	e3:SetOperation(cm.sumop1)
	c:RegisterEffect(e3)
	local e31=e3:Clone()
	e31:SetCode(EVENT_CUSTOM+m+1)
	c:RegisterEffect(e31)
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCondition(cm.sumcon2)
	e4:SetTarget(cm.sumtg2)
	e4:SetOperation(cm.sumop2)
	c:RegisterEffect(e4)
	local e41=e4:Clone()
	e41:SetCode(EVENT_CUSTOM+m+1)
	c:RegisterEffect(e41)
	local e5=e3:Clone()
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCondition(cm.sumcon3)
	e5:SetTarget(cm.sumtg)
	e5:SetOperation(cm.sumop)
	c:RegisterEffect(e5)
	local e51=e5:Clone()
	e51:SetCode(EVENT_CUSTOM+m+1)
	c:RegisterEffect(e51)
	local e6=e3:Clone()
	e6:SetDescription(aux.Stringid(m,4))
	c:RegisterEffect(e6)
	local e61=e6:Clone()
	e61:SetCode(EVENT_CUSTOM+m+1)
	c:RegisterEffect(e61)
	local e7=e4:Clone()
	e7:SetDescription(aux.Stringid(m,4))
	c:RegisterEffect(e7)
	local e71=e7:Clone()
	e71:SetCode(EVENT_CUSTOM+m+1)
	c:RegisterEffect(e71)
	if not cm.global_check then
		cm.global_check=true
		local _Overlay=Duel.Overlay
		function Duel.Overlay(xc,v,...)
			local t=Auxiliary.GetValueType(v)
			local g=Group.CreateGroup()
			if t=="Card" then g:AddCard(v) else g=v end
			if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
				Duel.RaiseEvent(g:Filter(Card.IsLocation,nil,LOCATION_DECK),EVENT_CUSTOM+m+1,e,0,0,0,0)
			end
			return _Overlay(xc,v,...)
		end
	end
end
function cm.filter(c)
	return c:IsType(TYPE_FLIP) and c:IsAbleToHand()
end
function cm.SpiritReturnReg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0xd6e0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(Auxiliary.SpiritReturnConditionForced)
	e1:SetTarget(Auxiliary.SpiritReturnTargetForced)
	e1:SetOperation(Auxiliary.SpiritReturnOperation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(Auxiliary.SpiritReturnConditionOptional)
	e2:SetTarget(Auxiliary.SpiritReturnTargetOptional)
	c:RegisterEffect(e2)
end
function cm.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK) and not (c:IsLocation(LOCATION_DECK) and c:IsControler(c:GetPreviousControler())) and c:IsFaceup()
end
function cm.cfilter2(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK) and not (c:IsLocation(LOCATION_DECK) and c:IsControler(c:GetPreviousControler())) and c:IsFacedown()
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,1-tp) and not eg:IsExists(cm.cfilter2,1,nil,1-tp)
end
function cm.sumcon2(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsExists(cm.cfilter,1,nil,1-tp) and eg:IsExists(cm.cfilter2,1,nil,1-tp)
end
function cm.sumcon3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,1-tp) and eg:IsExists(cm.cfilter2,1,nil,1-tp)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(cm.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.smfilter(c)
	return c:IsSummonable(true,nil) or c:IsMSetable(true,nil)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,nil)
		local s2=tc:IsMSetable(true,nil)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil)
		else
			Duel.MSet(tp,tc,true,nil)
		end
	end
end
function cm.sumtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,true,nil) and e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.sumop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,true,nil)
	local tc=g:GetFirst()
	if tc then Duel.Summon(tp,tc,true,nil) end
end
function cm.sumtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(Card.IsMSetable,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,true,nil) and e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.sumop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,Card.IsMSetable,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,true,nil)
	local tc=g:GetFirst()
	if tc then Duel.MSet(tp,tc,true,nil) end
end