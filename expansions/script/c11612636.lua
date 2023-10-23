--龙仪巧-小熊流星＝URS
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
local m=11612636
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/11610000") end) then require("script/11610000") end
cm.text=zhc_lhq_xx
function c11612636.initial_effect(c)
	 c:EnableReviveLimit()
	 --
	local e00=fpjdiy.Zhc(c,cm.text)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(11612636,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c11612636.valcheck)
	c:RegisterEffect(e0)
--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c11612636.efilter)
	c:RegisterEffect(e2)
  --damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c11612636.rmcon)
	e3:SetOperation(c11612636.rmop)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c11612636.matcon)
	e3:SetOperation(c11612636.matop)
	c:RegisterEffect(e3)
	e0:SetLabelObject(e3)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(11612636,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11612636)
	e2:SetTarget(c11612636.thtg)
	e2:SetOperation(c11612636.thop)
	c:RegisterEffect(e2)
end
function c11612636.efilter(e,te)
	local tc=te:GetOwner()
	local c=e:GetHandler()
	return not tc:IsLevelAbove(0) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c11612636.lvfilter(c,rc)
	return c:GetRitualLevel(rc)>0
end
function c11612636.valcheck(e,c)
	local mg=c:GetMaterial()
	local fg=mg:Filter(c11612636.lvfilter,nil,c)
	if #fg>0 and fg:GetSum(Card.GetRitualLevel,c)<=2 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c11612636.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetLabel()==1
end
function c11612636.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(11612636,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11612636,0))
end
function c11612636.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsLevel(0)
end
function c11612636.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c11612636.cfilter,1,nil,1-tp) and e:GetHandler():GetFlagEffect(11612636)>0
end
function c11612636.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,2)
	Duel.Hint(HINT_CARD,0,11612636)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
--
function c11612636.thfilter(c)
	return c:IsCode(22398665) and c:IsAbleToHand()
end
function c11612636.sfilter(c,e,tp)
	return c:IsSetCard(0x154) and c:IsType(TYPE_MONSTER) and c:IsLevel(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11612636.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11612636.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c11612636.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11612636.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c11612636.sfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp) and c:IsAbleToRemove() and Duel.SelectYesNo(tp,aux.Stringid(11612636,1)) then
			if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)<1 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11612636.sfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			if sg:GetCount()>0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end