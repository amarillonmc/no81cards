--惊诧魔术
function c12057828.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,12057828) 
	e1:SetTarget(c12057828.actg) 
	e1:SetOperation(c12057828.acop)  
	c:RegisterEffect(e1)  
	--SpecialSummon 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12057828,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,22057828)  
	e2:SetCondition(c12057828.hspcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c12057828.sptg)
	e2:SetOperation(c12057828.spop)
	c:RegisterEffect(e2)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c12057828.handcon)
	c:RegisterEffect(e3)
end 
function c12057828.xckfil(c)
	return c:IsFaceup() and c:IsDefenseAbove(3000)
end
function c12057828.handcon(e)
	return Duel.IsExistingMatchingCard(c12057828.xckfil,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end 
function c12057828.filter1(c,e)
	return not c:IsImmuneToEffect(e) and c:IsAbleToDeck() 
end
function c12057828.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c12057828.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanChangePosition,tp,LOCATION_MZONE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,Card.IsCanChangePosition,tp,LOCATION_MZONE,0,1,2,nil) 
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,2,0,0) 
end 
function c12057828.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS) 
	local dg=g:Filter(Card.IsRelateToEffect,nil,e) 
	if dg:GetCount()<=0 then return end 
	local tc=dg:GetFirst() 
	while tc do 
	local op=3 
	local ad=0 
	local dd=0 
	if tc:IsPosition(POS_FACEUP_DEFENSE+POS_FACEDOWN_ATTACK) then 
	op=Duel.SelectOption(tp,aux.Stringid(12057828,1),aux.Stringid(12057828,2)) 
	 if op==0 then 
	 ad=POS_FACEDOWN_DEFENSE  
	 du=POS_FACEDOWN_DEFENSE	
	 else 
	 ad=POS_FACEUP_ATTACK 
	 du=POS_FACEUP_ATTACK   
	 end 
	end 
	if op==3 then 
	ad=POS_FACEDOWN_ATTACK 
	du=POS_FACEUP_DEFENSE 
	end 
	Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE,ad,du,POS_FACEUP_ATTACK)   
	tc=dg:GetNext() 
	end 
	local chkf=tp 
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(c12057828.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c12057828.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end 
	if not res then return end 
	if not Duel.SelectYesNo(tp,aux.Stringid(12057828,3)) then return end  
	local mg1=Duel.GetFusionMaterial(tp):Filter(c12057828.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c12057828.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c12057828.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoDeck(mat1,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP_DEFENSE)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure() 
	end 
end 
function c12057828.hspcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c12057828.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.IsExistingMatchingCard(c12057828.stfil,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end 
function c12057828.stfil(c,e,tp) 
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,TYPE_MONSTER+TYPE_NORMAL,0,0,0,0,0,POS_FACEDOWN_DEFENSE) and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEDOWN_DEFENSE)
end 
function c12057828.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and Duel.IsExistingMatchingCard(c12057828.spfil,tp,LOCATION_GRAVE,0,1,c,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c12057828.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g1=Duel.GetMatchingGroup(c12057828.spfil,tp,LOCATION_GRAVE,0,nil,e,tp) 
	local g2=Duel.GetMatchingGroup(c12057828.stfil,tp,LOCATION_GRAVE,0,c,e,tp) 
	if g1:GetCount()<=0 or g2:GetCount()<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end 
	local tc1=g1:Select(tp,1,1,nil):GetFirst() 
	local tc2=g2:Select(tp,1,1,nil):GetFirst() 
		Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		local e1=Effect.CreateEffect(tc2)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		tc2:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_REMOVE_RACE)
		e2:SetValue(RACE_ALL)
		tc2:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
		e3:SetValue(0xff)
		tc2:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(0)
		tc2:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(0)
		tc2:RegisterEffect(e5,true)
		tc2:SetStatus(STATUS_NO_LEVEL,true) 
		Duel.SpecialSummon(tc2,0,tp,tp,true,true,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,Group.FromCards(tc1,tc2))  
		local ng=Group.FromCards(tc1,tc2)
	Duel.ShuffleSetCard(ng) 
end 



