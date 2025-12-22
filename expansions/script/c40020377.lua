--CB 菲尔特·古蕾斯
local s,id=GetID()
s.ui_hint_effect = s.ui_hint_effect or {}
local CORE_ID = 40020353 
local ArmedIntervention = CORE_ID   
local ArmedIntervention_UI = CORE_ID + 10000
--CB
s.named_with_CelestialBeing=1
function s.CelestialBeing(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_CelestialBeing
end

function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetCondition(s.plcon)
	e2:SetTarget(s.pltg)
	e2:SetOperation(s.plop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(id)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true  
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCondition(s.ui_update_con)
		ge1:SetOperation(s.ui_update_op)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.thcfilter(c)
	return c:IsRace(RACE_MACHINE) and s.CelestialBeing(c) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thcfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,sg)
			local tc=sg:GetFirst()
			if tc:IsLocation(LOCATION_HAND) and tc:IsCode(40020353) 
			   and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			   and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) 
			   and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end

function s.cfilter(c,tp)
	return c:IsCode(40020353) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end

function s.plcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end

function s.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	local g=eg:Filter(s.cfilter,nil,tp)
	Duel.SetTargetCard(g)
end

function s.plop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			 if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
				 local e1=Effect.CreateEffect(e:GetHandler())
				 e1:SetCode(EFFECT_CHANGE_TYPE)
				 e1:SetType(EFFECT_TYPE_SINGLE)
				 e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				 e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				 e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				 tc:RegisterEffect(e1)
			 end
		end
	end
end
function s.ui_update_con(e,tp,eg,ep,ev,re,r,rp)
	local c0 = Duel.GetFlagEffect(0, ArmedIntervention)
	local c1 = Duel.GetFlagEffect(1, ArmedIntervention)
	local old_val = e:GetLabel()
	local old_c0 = old_val & 0xFFFF
	local old_c1 = (old_val >> 16) & 0xFFFF
	
	return c0 ~= old_c0 or c1 ~= old_c1
end
function s.ui_update_op(e,tp,eg,ep,ev,re,r,rp)
	local c0 = Duel.GetFlagEffect(0, ArmedIntervention)
	local c1 = Duel.GetFlagEffect(1, ArmedIntervention)
	e:SetLabel((c1 << 16) | c0)
	s.update_player_ui(0, c0)
	s.update_player_ui(1, c1)
end
function s.update_player_ui(p, count)
	local old=s.ui_hint_effect[p]
	if old then
		old:Reset()
		s.ui_hint_effect[p]=nil
	end
	if count==0 then return end
	local str_index
	if count>=10 then
		str_index=13 
	else
		str_index=2+count 
	end
	local e=Effect.GlobalEffect()
	e:SetType(EFFECT_TYPE_FIELD)
	e:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e:SetCode(ArmedIntervention_UI)
	e:SetTargetRange(1,0)
	e:SetDescription(aux.Stringid(CORE_ID, str_index))
	Duel.RegisterEffect(e, p)
	s.ui_hint_effect[p]=e
end