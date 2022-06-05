--十历龙 完全驾驭
function c25000027.initial_effect(c)
	c:SetUniqueOnField(1,1,25000027)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e1:SetCondition(c25000027.sprcon)
	e1:SetTarget(c25000027.sprtg)
	e1:SetOperation(c25000027.sprop)
	c:RegisterEffect(e1)   
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1) 
	e2:SetTarget(c25000027.sptg)
	e2:SetOperation(c25000027.spop) 
	c:RegisterEffect(e2)
	--copy 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(c25000027.cptg)
	e3:SetOperation(c25000027.cpop)
	c:RegisterEffect(e3)
end
function c25000027.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(Card.IsRace,nil,RACE_DRAGON)
	return rg:CheckSubGroup(aux.mzctcheckrel,3,3,tp)
end
function c25000027.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(Card.IsRace,nil,RACE_DRAGON)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,aux.mzctcheckrel,true,3,3,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c25000027.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end
function c25000027.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and not c:IsSummonableCard() 
end
function c25000027.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25000027.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c25000027.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c25000027.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)  
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	local tc=sg:GetFirst()
		local code=tc:GetOriginalCodeRule()
		local cid=0
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if not tc:IsType(TYPE_TRAPMONSTER) then
			cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
		end
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(25000027,1))
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetCountLimit(1)
		e3:SetRange(LOCATION_MZONE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetLabelObject(e1)
		e3:SetLabel(cid)
		e3:SetOperation(c25000027.rstop)
		c:RegisterEffect(e3) 
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(25000027,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c25000027.tgcon)
		e1:SetOperation(c25000027.tgop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c25000027.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then
		c:ResetEffect(cid,RESET_COPY)
		c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	end
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c25000027.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(25000027)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c25000027.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Release(e:GetLabelObject(),REASON_EFFECT)
end
function c25000027.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(Card.IsType,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,TYPE_MONSTER) end 
	local tc1=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil) 
	local tc2=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil,TYPE_MONSTER) 
	local g=Group.FromCards(tc1,tc2) 
	Duel.SetTargetCard(g)
end	 
function c25000027.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc1=g:GetFirst() 
	local tc2=g:GetNext()  
	if tc1:IsRelateToEffect(e) and tc2:IsRelateToEffect(e) then 
	local sc1=g:Filter(Card.IsOnField,nil):GetFirst()
	local sc2=g:Filter(nil,sc1):GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(sc2:GetCode())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		sc1:RegisterEffect(e1)
		local e2=e1:Clone() 
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(sc2:GetAttribute())
		sc1:RegisterEffect(e2)
		local e3=e1:Clone() 
		e3:SetCode(EFFECT_CHANGE_RACE)
		e3:SetValue(sc2:GetRace())
		sc1:RegisterEffect(e3)  
	end
end





