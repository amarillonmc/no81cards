--狱炎之零点龙 德拉库玛
local m=40009054
local cm=_G["c"..m]
cm.named_with_ZerothDragon=1
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),4,4)
	c:EnableReviveLimit()   
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.con)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(cm.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3) 
	--disable search
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_TO_HAND)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetCondition(cm.con)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
	c:RegisterEffect(e4)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_MATERIAL_CHECK)
	e8:SetValue(cm.valcheck)
	e8:SetLabelObject(e4)
	c:RegisterEffect(e8) 
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	if #g>0 and g:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)==#g then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()==1
end
function cm.filter2(c,e,tp)
	return  c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	Duel.BreakEffect()
		local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)--检测全部手牌
		if hg:GetCount()==0 then Duel.Win(tp,nil) return end--手牌数为0直接跳过
		local ct=3
		if hg==2 or hg==1 then
			ct=hg
		end
		local sg3=hg:Select(1-tp,ct,ct,nil)--尽可能选3张手牌
		local ct3=sg3:GetCount()
		Duel.ConfirmCards(tp,sg3)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
		local ct2=2
		if sg3==1 then
			ct2=1
		end
		local tg=sg3:Select(1-tp,ct2,ct2,nil)--尽可能选2张手牌
		Duel.SendtoGrave(tg,REASON_EFFECT+REASON_DISCARD)
		local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)--检测全部手牌
		if hg:GetCount()==0 then Duel.Win(tp,nil) return end--手牌数为0直接跳过
		ct3=sg3:GetCount()-tg:GetCount()
		if ct3>0 then
			if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then Duel.Win(tp,nil) return end
			local spg=Duel.SelectMatchingCard(1-tp,cm.filter2,1-tp,LOCATION_HAND,0,1,1,nil,e,1-tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=spg:GetFirst()
			if tc then 
				Duel.SpecialSummon(tc,0,1-tp,1-tp,false,false,POS_FACEUP)
			else 
				Duel.Win(tp,nil)
			end
		end
		Duel.ShuffleHand(1-tp)
end








