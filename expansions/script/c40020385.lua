--CB 托勒密
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

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e0)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(s.lvtg)
	e1:SetValue(-1)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetTarget(s.estg)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,id+200)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,id+100)
	e4:SetTarget(s.eqtg)
	e4:SetOperation(s.eqop)
	c:RegisterEffect(e4)
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
function s.lvtg(e,c)
	return s.CelestialBeing(c) and c:IsType(TYPE_UNION) and c:IsLevelAbove(1)
end

function s.estg(e,c)
	return s.CelestialBeing(c)
end
function s.spfilter(c,e,tp)
	return s.CelestialBeing(c) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsLevelBelow(5) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end

	local owner=e:GetHandler():GetOwner()
	Duel.RegisterFlagEffect(owner,ArmedIntervention,0,0,0)
	
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
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
function s.eqtarget_filter(c,tp)
	return s.CelestialBeing(c) and c:IsRace(RACE_MACHINE) and c:IsFaceup()
end

function s.union_filter(c,tc,tp)
	return s.CelestialBeing(c) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_UNION)
		and c:CheckEquipTarget(tc) and not c:IsForbidden()
end

function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.eqtarget_filter(chkc,tp) end
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingTarget(function(c) 
				return s.eqtarget_filter(c,tp) and Duel.IsExistingMatchingCard(s.union_filter,tp,LOCATION_DECK,0,1,nil,c,tp)
			end,tp,LOCATION_MZONE,0,1,nil)
	end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,function(c) 
		return s.eqtarget_filter(c,tp) and Duel.IsExistingMatchingCard(s.union_filter,tp,LOCATION_DECK,0,1,nil,c,tp)
	end,tp,LOCATION_MZONE,0,1,1,nil)
	
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end

function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,s.union_filter,tp,LOCATION_DECK,0,1,1,nil,tc,tp)
		local uc=g:GetFirst()
		if uc then
			if Duel.Equip(tp,uc,tc) then
				 local e1=Effect.CreateEffect(e:GetHandler())
				 e1:SetType(EFFECT_TYPE_SINGLE)
				 e1:SetCode(EFFECT_EQUIP_LIMIT)
				 e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				 e1:SetValue(s.eqlimit)
				 e1:SetLabelObject(tc)
				 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				 uc:RegisterEffect(e1)
			end
		end
	end
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end

