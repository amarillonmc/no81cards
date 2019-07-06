--结缘
function c33700931.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(function(e,tp) return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==Duel.GetFieldGroupCount(tp,0,LOCATION_HAND) end)
	e1:SetTarget(c33700931.target)
	e1:SetOperation(c33700931.activate)
	c:RegisterEffect(e1)	
end
function c33700931.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanDraw(1-tp,2)
	local b2=true
	local b3=Duel.IsExistingMatchingCard(c33700931.atfilter,tp,0,LOCATION_MZONE,1,nil,tp) and Duel.IsExistingMatchingCard(c33700931.atfilter,1-tp,0,LOCATION_MZONE,1,nil,1-tp)
	if chk==0 then return b1 or b2 or b3 end
end
function c33700931.atfilter(c,tp)
	return c:IsFaceup() and c:IsDefenseAbove(0) and Duel.IsExistingMatchingCard(c33700931.atfilter2,tp,LOCATION_MZONE,0,1,nil,c:GetAttack(),c:GetDefense())
end
function c33700931.atfilter2(c,atk,def)
	return c:IsFaceup() and (c:GetAttack()~=atk or c:GetDefense()~=def)
end
function c33700931.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local player={tp,1-tp}
	local tf1,tf2,tf3=true,true,true
	for i=1,2 do
		local p=player[i]
		local b1=Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanDraw(1-tp,2) and tf1
		local b2=tf2
		local b3=Duel.IsExistingMatchingCard(c33700931.atfilter,tp,0,LOCATION_MZONE,1,nil,tp) and Duel.IsExistingMatchingCard(c33700931.atfilter,1-tp,0,LOCATION_MZONE,1,nil,1-tp) and tf3
		local off=1
		local ops={}
		local opval={}
		if b1 then
			ops[off]=aux.Stringid(33700931,0)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(33700931,1)
			opval[off-1]=2
			off=off+1
		end
		if b3 then
			ops[off]=aux.Stringid(33700931,2)
			opval[off-1]=3
			off=off+1
		end
		local op=Duel.SelectOption(p,table.unpack(ops))
		local sel=opval[op]
		Duel.Hint(HINT_OPSELECTED,1-p,aux.Stringid(33700931,sel-1))
		if sel==1 then
			Duel.Draw(p,2,REASON_EFFECT)
			local g1=Duel.GetOperatedGroup()
			Duel.Draw(1-p,2,REASON_EFFECT)
			local g2=Duel.GetOperatedGroup()
			g1:Merge(g2)
			local fid=c:GetFieldID()
			for tc in aux.Next(g1) do
				tc:RegisterFlagEffect(33700931,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
			end
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetCountLimit(1)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			g1:KeepAlive()
			e2:SetLabelObject(g1)
			e2:SetLabel(fid)
			e2:SetCondition(c33700931.tgcon)
			e2:SetOperation(c33700931.tgop)
			Duel.RegisterEffect(e2,tp)
			tf1=false
		elseif sel==2 then
			for i=1,2 do 
				local p2=player[i]
				local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsCanBeSpecialSummoned),p2,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,0,p2,false,false)
				if Duel.GetLocationCount(p2,LOCATION_MZONE)>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(33700931,3)) then
					Duel.Hint(HINT_SELECTMSG,p2,HINTMSG_SPSUMMON)
					local sg=g:Select(p2,1,1,nil)
					Duel.SpecialSummon(sg,0,p2,p2,false,false,POS_FACEUP)
				end
			end
			tf2=false
		elseif sel==3 then
		   for i=1,2 do 
				local p2=player[i]
				Duel.Hint(HINT_SELECTMSG,p2,HINTMSG_OPPO)
				local a1=Duel.SelectMatchingCard(p2,c33700931.atfilter,p2,0,LOCATION_MZONE,1,1,nil,p2)
				Duel.HintSelection(a1)
				local ac=a1:GetFirst()
				local atk,def=ac:GetAttack(),ac:GetDefense()
				local ag=Duel.GetMatchingGroup(c33700931.atfilter2,p2,LOCATION_MZONE,0,nil,atk,def)
				for tc in aux.Next(ag) do
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetCode(EFFECT_SET_ATTACK_FINAL)
					e1:SetValue(atk)
					tc:RegisterEffect(e1)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
					e2:SetValue(def)
					tc:RegisterEffect(e2)
				end
		   end
		   tf3=false
		end
	end
end
function c33700931.tdcfilter(c,fid)
	return c:GetFlagEffectLabel(33700931)==fid
end
function c33700931.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c33700931.tdcfilter,nil,e:GetLabel())
	if #tg>0 then return true
	else
		g:DeleteGroup()
		e:Reset()
	return false
	end
end
function c33700931.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10174020)
	local g=e:GetLabelObject()
	local tg=g:Filter(c33700931.tdcfilter,nil,e:GetLabel())
	Duel.SendtoGrave(tg,REASON_EFFECT)
end