--极天之零点龙 乌尔提玛
local m=40008180
local cm=_G["c"..m]
cm.named_with_ZerothDragon=1
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionType,TYPE_MONSTER),5,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(cm.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--special summon
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_RELEASE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetTargetRange(0,1)
	e9:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	e9:SetCondition(cm.con)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_MATERIAL_CHECK)
	e10:SetValue(cm.valcheck)
	e10:SetLabelObject(e9)
	c:RegisterEffect(e10)
	--cannot set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_MSET)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetTarget(aux.TRUE)
	e4:SetCondition(cm.con)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e7:SetTarget(cm.sumlimit)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_MATERIAL_CHECK)
	e8:SetValue(cm.valcheck)
	e8:SetLabelObject(e4)
	c:RegisterEffect(e8)
end
function cm.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(24094653)
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)>0
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	if g:FilterCount(Card.IsType,nil,TYPE_FUSION)==#g then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()==1
end
function cm.thfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,4,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>=4 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,4,4,nil)
			Duel.ConfirmCards(1-tp,sg)
				if sg:GetCount()>0 then
				local tg=sg:Select(tp,2,2,nil)
				Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
				sg:Sub(tg)
			end
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)
		end
	end
end