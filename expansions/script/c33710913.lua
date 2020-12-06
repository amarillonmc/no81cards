--永恒的约定
function c33710913.initial_effect(c)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33710913+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(c33710913.target)
	e1:SetOperation(c33710913.activate)
	c:RegisterEffect(e1)
end
function c33710913.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,1,nil,tp,POS_FACEDOWN,REASON_EFFECT) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_EXTRA,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function c33710913.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,33710913)~=0 then return end
	Duel.RegisterFlagEffect(tp,33710913,0,0,0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33710913.splimit1)
	Duel.RegisterEffect(e1,tp)
	local flag=1
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,nil,tp,POS_FACEDOWN,REASON_EFFECT)
	if Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)~=0 then
		if Duel.SelectYesNo(tp,aux.Stringid(33710913,2)) then
			Duel.PayLPCost(tp,2000)
			flag=0
			local token1=Duel.CreateToken(tp,33710928)
			Duel.SendtoDeck(token1,tp,0,REASON_EFFECT)
			local token2=Duel.CreateToken(tp,33710916)
			Duel.SendtoDeck(token2,tp,0,REASON_EFFECT)
			local token3=Duel.CreateToken(tp,33710917)
			Duel.SendtoDeck(token3,tp,0,REASON_EFFECT)
			local token4=Duel.CreateToken(tp,33710918)
			Duel.SendtoDeck(token4,tp,0,REASON_EFFECT)
			local token5=Duel.CreateToken(tp,33710915)
			Duel.SendtoDeck(token5,tp,0,REASON_EFFECT)
		end
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetOperation(c33710913.gain)
		e1:SetLabel(flag)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetLabel(flag)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(e2,tp)
	end
end
function c33710913.gain(e,tp,eg,ep,ev,re,r,rp)
	local flag=e:GetLabel()
	local tg=eg:Filter(Card.IsControler,nil,tp)
	local tc=tg:GetFirst()
	stack11={1,3,5}
	while tc and tc:GetFlagEffect(33710913)==0 do
		stsck1={1,3,5}
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33710913,4))
		local op=Duel.SelectOption(tp,aux.Stringid(33710913,stsck1[1]),aux.Stringid(33710913,stsck1[2]),aux.Stringid(33710913,stsck1[3]))
		local op1=op
		local flag2=0
		tc:RegisterFlagEffect(33710913,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(33710913,stack11[op1+1]))
		table.remove(stsck1,op1+1)
		if flag==1 then
			flag2=Duel.SelectOption(tp,aux.Stringid(33710913,stsck1[1]),aux.Stringid(33710913,stsck1[2]))
			tc:RegisterFlagEffect(33710913,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(33710913,stsck1[flag2+1]))
		end
		local sum=stack11[op+1]
		if flag~=0 then
			sum=sum+stsck1[flag2+1]
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_DESTROYED)
		e1:SetLabel(sum)
		e1:SetOperation(c33710913.op0)
		tc:RegisterEffect(e1,true)
		tc=tg:GetNext()
	end
end
function c33710913.op0(e)
	local num=e:GetLabel()
	if num==1 then
		if Duel.IsPlayerCanDraw(e:GetHandler():GetControler(),1) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	elseif num==3 then
		if Duel.IsExistingMatchingCard(aux.TRUE,e:GetHandler():GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,e:GetHandler():GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif num==4 then
		if Duel.IsPlayerCanDraw(e:GetHandler():GetControler(),1) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		if Duel.IsExistingMatchingCard(aux.TRUE,e:GetHandler():GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,e:GetHandler():GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif num==5 then
		local g=Duel.GetMatchingGroup(c33710913.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			tc:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
		end
	elseif num==6 then
		if Duel.IsPlayerCanDraw(e:GetHandler():GetControler(),1) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		local g=Duel.GetMatchingGroup(c33710913.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_DISABLE_EFFECT)
			tc:RegisterEffect(e4)
			Duel.SpecialSummonComplete()
		end
	else
		if Duel.IsExistingMatchingCard(aux.TRUE,e:GetHandler():GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,e:GetHandler():GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.Destroy(g,REASON_EFFECT)
		end
		local g=Duel.GetMatchingGroup(c33710913.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e5=Effect.CreateEffect(e:GetHandler())
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_DISABLE)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e5)
			local e6=e5:Clone()
			e6:SetCode(EFFECT_DISABLE_EFFECT)
			tc:RegisterEffect(e6)
			Duel.SpecialSummonComplete()
		end
	end
	e:Reset()
end
function c33710913.spfilter(c,e,tp)
	return c:IsLevel(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33710913.splimit1(e,c,tp,sumtp,sumpos)
	return not c:GetOriginalCode()==33710928 and c:IsLocation(LOCATION_EXTRA)
end