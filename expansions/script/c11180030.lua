--幻殇·玉麒
function c11180030.initial_effect(c) 
	--xx
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c11180030.LinkCondition(function(c) return c:IsLinkSetCard(0x3450) end,3,3,gf))
	e1:SetTarget(c11180030.LinkTarget(function(c) return c:IsLinkSetCard(0x3450) end,3,3,gf))
	e1:SetOperation(c11180030.LinkOperation(function(c) return c:IsLinkSetCard(0x3450) end,3,3,gf))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--cannot be link material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--xx
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11180030)
	e1:SetCondition(c11180030.xxcon1) 
	e1:SetTarget(c11180030.xxtg1) 
	e1:SetOperation(c11180030.xxop1)
	c:RegisterEffect(e1) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11180030)
	e1:SetCondition(c11180030.xxcon2) 
	e1:SetTarget(c11180030.xxtg2) 
	e1:SetOperation(c11180030.xxop2)
	c:RegisterEffect(e1)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetTarget(c11180030.reptg)
	e4:SetValue(c11180030.repval)
	c:RegisterEffect(e4)
end
function c11180030.slmfil(c) 
	return c:IsLinkSetCard(0x6450) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove() 
end 
function c11180030.LinkCondition(f,minct,maxct,gf)
	return  function(e,c,og,lmat,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c,e)
					if Duel.GetFlagEffect(tp,11180030)==0 then 
						local smg=Duel.GetMatchingGroup(c11180030.slmfil,tp,LOCATION_GRAVE,0,nil) 
						mg:Merge(smg)
					end 
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(Auxiliary.LCheckGoal,minc,maxc,tp,c,gf,lmat)
			end
end
function c11180030.LinkTarget(f,minct,maxct,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c,e)
					if Duel.GetFlagEffect(tp,11180030)==0 then 
						local smg=Duel.GetMatchingGroup(c11180030.slmfil,tp,LOCATION_GRAVE,0,nil)
						mg:Merge(smg)
					end 
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,Auxiliary.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function c11180030.LinkOperation(f,minct,maxct,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Auxiliary.LExtraMaterialCount(g,c,tp)
				local sg=g:Filter(c11180030.slmfil,nil):Filter(Card.IsLocation,nil,LOCATION_GRAVE) 
				if sg:GetCount()>0 then 
					g:Sub(sg)
					Duel.Remove(sg,POS_FACEUP,REASON_MATERIAL+REASON_LINK) 
					Duel.RegisterFlagEffect(tp,11180030,RESET_PHASE+PHASE_END,0,1)
				end 
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)  
				g:DeleteGroup()
			end
end 
function c11180030.xxcon1(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
end  
function c11180030.ctfil(c) 
	return c:IsAbleToRemoveAsCost() or c:IsAbleToGraveAsCost()
end 
function c11180030.negfil(c,xtype) 
	return c:IsType(xtype) and aux.NegateAnyFilter(c)
end 
function c11180030.ctgck1(g,tp) 
	local ct1=g:FilterCount(Card.IsType,nil,TYPE_MONSTER) 
	local ct2=g:FilterCount(Card.IsType,nil,TYPE_SPELL) 
	local ct3=g:FilterCount(Card.IsType,nil,TYPE_TRAP)  
	return (ct1==0 or Duel.IsExistingMatchingCard(c11180030.negfil,tp,0,LOCATION_ONFIELD,ct1,nil,TYPE_MONSTER))
	   and (ct2==0 or Duel.IsExistingMatchingCard(c11180030.negfil,tp,0,LOCATION_ONFIELD,ct2,nil,TYPE_SPELL))
	   and (ct3==0 or Duel.IsExistingMatchingCard(c11180030.negfil,tp,0,LOCATION_ONFIELD,ct3,nil,TYPE_TRAP))
end 
function c11180030.xxtg1(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c11180030.ctfil,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if chk==0 then return g:CheckSubGroup(c11180030.ctgck1,1,10,tp) end 
	local sg=g:SelectSubGroup(tp,c11180030.ctgck1,false,1,10,tp) 
	local ct1=sg:FilterCount(Card.IsType,nil,TYPE_MONSTER) 
	local ct2=sg:FilterCount(Card.IsType,nil,TYPE_SPELL) 
	local ct3=sg:FilterCount(Card.IsType,nil,TYPE_TRAP) 
	e:SetLabel(ct1,ct2,ct3)
	local tc=sg:GetFirst() 
	while tc do  
		Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
		if tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	tc=sg:GetNext() 
	end  
end 
function c11180030.xxop1(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local ct1,ct2,ct3=e:GetLabel() 
	local xg=Group.CreateGroup()
	if ct1>0 and Duel.IsExistingMatchingCard(c11180030.negfil,tp,0,LOCATION_ONFIELD,ct1,nil,TYPE_MONSTER) then 
		local sg=Duel.SelectMatchingCard(tp,c11180030.negfil,tp,0,LOCATION_ONFIELD,ct1,ct1,nil,TYPE_MONSTER) 
		xg:Merge(sg1)
	end 
	if ct2>0 and Duel.IsExistingMatchingCard(c11180030.negfil,tp,0,LOCATION_ONFIELD,ct2,nil,TYPE_SPELL) then 
		local sg=Duel.SelectMatchingCard(tp,c11180030.negfil,tp,0,LOCATION_ONFIELD,ct2,ct2,nil,TYPE_SPELL) 
		xg:Merge(sg)
	end 
	if ct3>0 and Duel.IsExistingMatchingCard(c11180030.negfil,tp,0,LOCATION_ONFIELD,ct3,nil,TYPE_TRAP) then 
		local sg=Duel.SelectMatchingCard(tp,c11180030.negfil,tp,0,LOCATION_ONFIELD,ct3,ct3,nil,TYPE_TRAP) 
		xg:Merge(sg)
	end 
	local tc=xg:GetFirst()
	while tc do 
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
	tc=xg:GetNext()
	end
end 
function c11180030.xxcon2(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
end   
function c11180030.setfil(c,xtype) 
	if not c:IsType(xtype) then return false end 
	if rc:IsType(TYPE_MONSTER) then
		return rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) 
	else  
		return rc:IsSSetable(true) 
	end
end 
function c11180030.ctgck2(g,tp) 
	local ct1=g:FilterCount(Card.IsType,nil,TYPE_MONSTER) 
	local ct2=g:FilterCount(Card.IsType,nil,TYPE_SPELL) 
	local ct3=g:FilterCount(Card.IsType,nil,TYPE_TRAP)  
	return (ct1==0 or Duel.IsExistingMatchingCard(c11180030.negfil,tp,0,LOCATION_DECK,ct1,nil,TYPE_MONSTER))
	   and (ct2==0 or Duel.IsExistingMatchingCard(c11180030.negfil,tp,0,LOCATION_DECK,ct2,nil,TYPE_SPELL))
	   and (ct3==0 or Duel.IsExistingMatchingCard(c11180030.negfil,tp,0,LOCATION_DECK,ct3,nil,TYPE_TRAP))
	   and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct1 
	   and Duel.GetLocationCount(tp,LOCATION_SZONE)>=ct2+ct3
end 
function c11180030.xxtg2(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c11180030.ctfil,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if chk==0 then return g:CheckSubGroup(c11180030.ctgck2,1,10,tp) end 
	local sg=g:SelectSubGroup(tp,c11180030.ctgck2,false,1,10,tp) 
	local ct1=sg:FilterCount(Card.IsType,nil,TYPE_MONSTER) 
	local ct2=sg:FilterCount(Card.IsType,nil,TYPE_SPELL) 
	local ct3=sg:FilterCount(Card.IsType,nil,TYPE_TRAP) 
	e:SetLabel(ct1,ct2,ct3)
	local tc=sg:GetFirst() 
	while tc do  
		Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
		if tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	tc=sg:GetNext() 
	end  
end 
function c11180030.xxop2(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local ct1,ct2,ct3=e:GetLabel()  
	if ct1>0 and Duel.IsExistingMatchingCard(c11180030.setfil,tp,0,LOCATION_DECK,ct1,nil,TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct1 then 
		local sg=Duel.SelectMatchingCard(tp,c11180030.setfil,tp,0,LOCATION_DECK,ct1,ct1,nil,TYPE_MONSTER) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
	local xg=Group.CreateGroup() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<ct2+ct3 then return false end 
	if ct2>0 and Duel.IsExistingMatchingCard(c11180030.setfil,tp,0,LOCATION_DECK,ct2,nil,TYPE_SPELL) then 
		local sg=Duel.SelectMatchingCard(tp,c11180030.setfil,tp,0,LOCATION_DECK,ct2,ct2,nil,TYPE_SPELL) 
		xg:Merge(sg)
	end 
	if ct3>0 and Duel.IsExistingMatchingCard(c11180030.setfil,tp,0,LOCATION_DECK,ct3,nil,TYPE_TRAP) then 
		local sg=Duel.SelectMatchingCard(tp,c11180030.setfil,tp,0,LOCATION_DECK,ct3,ct3,nil,TYPE_TRAP) 
		xg:Merge(sg)
	end 
	Duel.SSet(tp,xg)
end 
function c11180030.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x3450,0x6450) and (c:IsReason(REASON_DESTROY) or c:GetDestination()==LOCATION_REMOVED) and not c:IsReason(REASON_REPLACE)
end
function c11180030.repfil(c) 
	return c:IsSetCard(0x3450,0x6450) and c:IsAbleToRemove() 
end 
function c11180030.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c11180030.repfilter,1,nil,tp) and Duel.IsExistingMatchingCard(c11180030.repfil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(11180030,3)) then
		local sg=Duel.SelectMatchingCard(tp,c11180030.repfil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil) 
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
		return true 
	else return false end
end
function c11180030.repval(e,c)
	return c11180030.repfilter(c,c:GetControler())
end

