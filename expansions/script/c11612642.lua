--龙仪巧-盾牌流星＝SCU
if not require and loadfile then
	function require(str)
		require_list=require_list or {}
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			require_list[str]()
			return require_list[str]
		end
		return require_list[str]
	end
end
local m=11612642
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/11610000") end) then require("script/11610000") end
cm.text=zhc_lhq_dp
function c11612642.initial_effect(c)
	c:EnableReviveLimit()
	 --
	local e00=fpjdiy.Zhc(c,cm.text)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(11612642,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c11612642.valcheck)
	c:RegisterEffect(e0)
--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_GRAVE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x154))
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetCondition(c11612642.econ)
	e1:SetTarget(c11612642.etg)
	e1:SetValue(c11612642.efilter)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c11612642.matcon)
	e3:SetOperation(c11612642.matop)
	c:RegisterEffect(e3)
	e0:SetLabelObject(e3)
 --negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11612642,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,11612642)
	e2:SetCondition(c11612642.negcon)
	e2:SetTarget(c11612642.negtg)
	e2:SetOperation(c11612642.negop)
	c:RegisterEffect(e2)
end
function c11612642.lvfilter(c,rc)
	return c:GetRitualLevel(rc)>0
end
function c11612642.valcheck(e,c)
	local mg=c:GetMaterial()
	local fg=mg:Filter(c11612642.lvfilter,nil,c)
	if #fg>0 and fg:GetSum(Card.GetRitualLevel,c)<=2 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c11612642.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetLabel()==1
end
function c11612642.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(11612642,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11612642,0))
end
function c11612642.econ(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(11612642)>0
end
function c11612642.etg(e,c)
	local seq=c:GetSequence()
	return c:IsSetCard(0x154) and c~=e:GetHandler() and seq<5 and math.abs(e:GetHandler():GetSequence()-seq)<=1
end
function c11612642.efilter(e,re)
  return not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c11612642.tfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x154) and c:IsControler(tp)
end
function c11612642.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g:GetCount()>0 and rp==1-tp and g:FilterCount(c11612642.tfilter,nil,tp)==#g
end
function c11612642.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c11612642.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP_DEFENSE)>0 then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(0)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	 e3:SetType(EFFECT_TYPE_SINGLE)
	 e3:SetCode(EFFECT_DISABLE_EFFECT)
	 e3:SetValue(RESET_TURN_SET)
	 e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	 c:RegisterEffect(e3)
	 Duel.BreakEffect()
	 Duel.ChangeTargetCard(ev,Group.FromCards(c))
	 end
end