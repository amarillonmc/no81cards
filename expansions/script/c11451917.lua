--真白梦游地下界
local cm,m=GetID()
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.sumcon)
	e2:SetTarget(cm.sumtg)
	e2:SetOperation(cm.sumop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(cm.regop)
	c:RegisterEffect(e3)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.efilter(e)
	return e:GetCode()==EVENT_SUMMON_SUCCESS and e:IsActivated() and not e:IsHasType(EFFECT_TYPE_SINGLE)
end
function cm.efilter2(e)
	return ((e:IsHasCategory(CATEGORY_TOHAND) or e:IsHasCategory(CATEGORY_DRAW)) and e:IsActivated()) or (e:GetHandler():IsType(TYPE_SPIRIT) and not e:GetHandler():IsExtraDeckMonster() and e:GetType()&0x801==0x801 and (e:GetCode()==EVENT_SUMMON_SUCCESS or e:GetCode()==EVENT_FLIP) and e:IsHasProperty(EFFECT_FLAG_CANNOT_DISABLE))
end
function cm.spfilter(c)
	return c:IsOriginalEffectProperty(cm.efilter) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
local _IsCanTurnSet=Card.IsCanTurnSet
function Card.IsCanTurnSet(c)
	return (c:IsSSetable(true) and c:IsLocation(LOCATION_SZONE)) or ((_IsCanTurnSet(c) and not c:IsLocation(LOCATION_SZONE) and not c:IsStatus(STATUS_BATTLE_DESTROYED)))
end
function cm.dsfilter(c)
	return c:IsFaceup() and c:IsOnField() and c:IsCanTurnSet() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local rg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,aux.ExceptThisCard(e))
		--Duel.HintSelection(rg)
		local rc=rg:GetFirst()
		local set=false --cm.dsfilter(rc) or (not rc:IsOnField() and rc:IsSSetable())
		local sp=false --not rc:IsOnField() and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetMZoneCount(tp)>0
		if set or sp then
			local opt=aux.SelectFromOptions(tp,{true,aux.Stringid(m,1)},{set,aux.Stringid(m,2)},{sp,aux.Stringid(m,3)})
			if opt==1 then
				Duel.SendtoGrave(rg,REASON_EFFECT)
			elseif opt==2 then
				if rc:IsOnField() then
					rc:CancelToGrave()
					Duel.ChangePosition(rg,POS_FACEDOWN_DEFENSE)
				else
					Duel.SSet(tp,rg,tp,false)
				end
			else
				if Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then Duel.ConfirmCards(1-tp,rc) end
			end
		else
			Duel.SendtoGrave(rg,REASON_EFFECT)
		end
	end
end
function cm.spfilter2(c)
	return c:IsOriginalEffectProperty(cm.efilter2) and c:IsPreviousPosition(POS_FACEUP)
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)~=0 and eg:IsExists(cm.spfilter2,1,nil)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.smfilter(c)
	return c:IsSummonable(true,nil) or c:IsMSetable(true,nil)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
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