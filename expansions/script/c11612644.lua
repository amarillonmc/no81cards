--龙仪巧-鲸鱼流星＝CET
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
local m=11612644
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/11610000") end) then require("script/11610000") end
cm.text=zhc_lhq_jy
function c11612644.initial_effect(c)
	c:EnableReviveLimit()
	local e00=fpjdiy.Zhc(c,cm.text)
	 --
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(11612644,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c11612644.valcheck)
	c:RegisterEffect(e0)
 --defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
 --atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11612644,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(c11612644.indcon)
	e3:SetOperation(c11612644.atkop)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11612644,2))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,11612644)
	e1:SetCondition(c11612644.thcon)
	e1:SetTarget(c11612644.thtg)
	e1:SetOperation(c11612644.thop)
	c:RegisterEffect(e1)
	 local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c11612644.matcon)
	e3:SetOperation(c11612644.matop)
	c:RegisterEffect(e3)
	e0:SetLabelObject(e3)
 --token
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(11612644,3))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	--e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,11612645)
	e5:SetCondition(c11612644.spcon)
	e5:SetTarget(c11612644.sptg)
	e5:SetOperation(c11612644.spop)
	c:RegisterEffect(e5)
end
function c11612644.lvfilter(c,rc)
	return c:GetRitualLevel(rc)>0
end
function c11612644.valcheck(e,c)
	local mg=c:GetMaterial()
	local fg=mg:Filter(c11612644.lvfilter,nil,c)
	if #fg>0 and fg:GetSum(Card.GetRitualLevel,c)<=2 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c11612644.indcon(e)
	return e:GetHandler():IsDefensePos() and aux.bdocon(e)
end
function c11612644.atkop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local rec=c:GetBaseDefense()
		if rec<0 then rec=0 end
		local tc=mg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(rec*-1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			tc=mg:GetNext()
		end
end
function c11612644.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetLabel()==1
end
function c11612644.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(11612644,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11612644,0))
end
function c11612644.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(11612644)>0
end
function c11612644.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_DECK,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11612644.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetDecktopGroup(1-tp,2)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g2=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Select(tp,1,1,nil)
		if g2:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end
function c11612644.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousControler(tp)  and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY)
end
function c11612644.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if chk==0 then return (ft1>0 or ft2>0) and Duel.IsPlayerCanSpecialSummonMonster(tp,11612645,0x154,TYPES_TOKEN_MONSTER,2000,0,1,RACE_MACHINE,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE)  and Duel.IsPlayerCanSpecialSummonMonster(tp,11612645,0x154,TYPES_TOKEN_MONSTER,2000,0,1,RACE_MACHINE,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE,1-tp)  end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,nil,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,nil,0,0)
end
function c11612644.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local fid=c:GetFieldID()
	local g=Group.CreateGroup() 
	if ft1<=0 and ft2<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,11612645,0x154,TYPES_TOKEN_MONSTER,2000,0,1,RACE_MACHINE,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE)  and Duel.IsPlayerCanSpecialSummonMonster(tp,11612645,0x154,TYPES_TOKEN_MONSTER,2000,0,1,RACE_MACHINE,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE,1-tp) then 
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft1=1	end
		for i=1,ft1 do
			local token=Duel.CreateToken(tp,11612645)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			token:RegisterFlagEffect(11612644,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)		   g:AddCard(token)
		end
		if not Duel.IsPlayerAffectedByEffect(tp,59822133) then 
			for i=1,ft2 do
				token=Duel.CreateToken(tp,11612645)
				Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
				token:RegisterFlagEffect(11612644,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
				g:AddCard(token)
			end
		end
	end
	Duel.SpecialSummonComplete()
	g:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetLabelObject(g)
	e1:SetCondition(c11612644.descon)
	e1:SetOperation(c11612644.desop)
	Duel.RegisterEffect(e1,tp)
end
function c11612644.desfilter(c)
	return c:GetFlagEffect(11612644)~=0
end
function c11612644.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c11612644.desfilter,nil)
	return Duel.GetTurnCount()~=e:GetLabel() and #tg>=0
end
function c11612644.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c11612644.desfilter,nil)
	g:DeleteGroup()
	Duel.Destroy(tg,REASON_EFFECT)
end   