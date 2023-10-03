--幻异梦境-昭和胡同
if not c71401001 then dofile("expansions/script/c71400001.lua") end
function c71400037.initial_effect(c)
	--Activate
	--See AddYumeFieldGlobal
	--self to deck & activate field
	yume.AddYumeFieldGlobal(c,71400037,1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400037,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c71400037.tg1)
	e2:SetOperation(c71400037.op1)
	c:RegisterEffect(e2)
end
function c71400037.filter(c,e,tp)
	return c:IsSetCard(0x714) and c:IsLevel(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c71400037.filter1a(c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_XYZ) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c71400037.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c71400037.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c71400037.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local tg=1
	if Duel.IsExistingMatchingCard(c71400037.filter1,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) then
		tg=2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c71400037.filter,tp,LOCATION_GRAVE,0,1,tg,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c71400037.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetsRelateToChain()
	if g:GetCount()==0 then return end
	for tc in aux.Next(g) do
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(71400037,1))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_ATTACK_FINAL)
			e3:SetValue(0)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3,true)
			local e4=Effect.CreateEffect(c)
			e4:SetCategory(CATEGORY_DESTROY)
			e4:SetType(EFFECT_TYPE_CONTINUOUS)
			e4:SetCode(EVENT_BECOME_TARGET)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			e4:SetCondition(c71400037.tgcon)
			e4:SetOperation(c71400037.tgop)
			c:RegisterEffect(e4,true)
			local e5=e4:Clone()
			e5:SetReset(RESET_EVENT+RESETS_STANDARD)
			e5:SetCode(EVENT_BE_BATTLE_TARGET)
			c:RegisterEffect(e5,true)
		end
	end
	Duel.SpecialSummonComplete()
end
function c71400037.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c71400037.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end