--龙仪巧-麒麟流星＝MON
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
local m=11612641
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/11610000") end) then require("script/11610000") end
cm.text=zhc_lhq_ql
function c11612641.initial_effect(c)
	c:EnableReviveLimit()
	 --
	local e00=fpjdiy.Zhc(c,cm.text)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(11612641,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c11612641.valcheck)
	c:RegisterEffect(e0)
--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PIERCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e3)
 --to grave
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(11612641,2))
	e8:SetCategory(CATEGORY_REMOVE)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1,11612641)
	e8:SetCondition(c11612641.econ)
	e8:SetTarget(c11612641.target)
	e8:SetOperation(c11612641.operation)
	c:RegisterEffect(e8)
   local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c11612641.matcon)
	e3:SetOperation(c11612641.matop)
	c:RegisterEffect(e3)
	e0:SetLabelObject(e3)
--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11612641,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,116126410)
	e2:SetCondition(c11612641.thcon)
	e2:SetTarget(c11612641.thtg)
	e2:SetOperation(c11612641.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
function c11612641.lvfilter(c,rc)
	return c:GetRitualLevel(rc)>0
end
function c11612641.valcheck(e,c)
	local mg=c:GetMaterial()
	local fg=mg:Filter(c11612641.lvfilter,nil,c)
	if #fg>0 and fg:GetSum(Card.GetRitualLevel,c)<=2 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c11612641.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetLabel()==1
end
function c11612641.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(11612641,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11612641,0))
end
function c11612641.econ(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(11612641)>0
end
function c11612641.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c11612641.operation(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetFieldGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	local sg=Duel.GetFieldGroup(Card.IsCode,tp,0,LOCATION_DECK,nil,ac)
	if g:GetCount()>0 then
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	 else 
		local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if hg:GetCount()==0 then return end
		Duel.ConfirmCards(1-tp,hg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=hg:Select(1-tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	end
end
function c11612641.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c11612641.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c11612641.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end