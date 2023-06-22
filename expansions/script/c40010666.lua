--哀恸魔女-幻惑之菲欧娜
local m=40010666
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c40010663") end,function() require("script/c40010663") end)
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_SPELLCASTER),1)
	c:EnableReviveLimit()
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e2:SetLabelObject(g)
end
cm.setname="WailWitch"

--e1
function cm.cfilter(c,tp)
	return (c:IsControler(tp) or (c:IsControler(1-tp) and c:IsType(TYPE_TOKEN))) and c:IsRace(RACE_SPELLCASTER) and c:IsReleasable()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,2,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,2,2,e:GetHandler(),tp)
	Duel.Release(g,REASON_COST)
end
function cm.filter(c,e,tp)
	return WW_N.ck(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) and tc:IsCode(40010668) and WW_TK.ck(tp) then
		WW_TK.op(e:GetHandler(),tp)
	end
end

--e2
function cm.repfilter(c,tp)
	return c:IsFaceup() and WW_N.ck(c) and c:IsLocation(LOCATION_MZONE)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and c:GetFlagEffect(id)==0
end
function cm.desfilter(c,e)
	return c:IsType(TYPE_TOKEN) and c:IsDestructable(e)
		and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=eg:FilterCount(cm.repfilter,nil,tp)
	if chk==0 then return ct>0
		and Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,ct,nil,e) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local tg=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,ct,ct,nil,e)
		local g=e:GetLabelObject()
		g:Clear()
		local tc=tg:GetFirst()
		while tc do
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
			tc:SetStatus(STATUS_DESTROY_CONFIRMED,true)
			g:AddCard(tc)
			tc=tg:GetNext()
		end
		return true
	else return false end
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local tg=e:GetLabelObject()
	local tc=tg:GetFirst()
	while tc do
		tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
		tc=tg:GetNext()
	end
	Duel.Destroy(tg,REASON_EFFECT+REASON_REPLACE)
end
