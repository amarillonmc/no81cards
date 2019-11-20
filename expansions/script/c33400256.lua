--本条二亚的再次复活
function c33400256.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,33400256)
	e2:SetOperation(c33400256.spop)
	c:RegisterEffect(e2) 
	  --confirm 1-TP
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,33400256+10000)
	e3:SetOperation(c33400256.operation2)
	c:RegisterEffect(e3)
end
function c33400256.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	 Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	local token=Duel.CreateToken(tp,ac)
	local t1=bit.band(token:GetType(),0x7)
	local t2=bit.band(tc:GetType(),0x7)
	if t1==t2  then 
		Duel.Damage(1-tp,500,REASON_EFFECT)  
	else 
		local g4=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
		Duel.SendtoGrave(g4,nil,REASON_EFFECT)
	end
	if tc:IsCode(ac) then 
	   if  Duel.IsExistingTarget(c33400256.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then 
		   if Duel.SelectYesNo(tp,aux.Stringid(33400256,0)) then
		   local tc1=Duel.SelectTarget(tp,c33400256.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		   local tc2=tc1:GetFirst()
		   Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP)
		   Duel.SpecialSummonComplete()
		   end
	   end
	   if tc:IsSetCard(0x341) and Duel.SelectYesNo(tp,aux.Stringid(33400256,1))then 
		Duel.SendtoGrave(tc,REASON_EFFECT)
	   else  Duel.MoveSequence(tc,1)  
	   end  
	end
end
function c33400256.spfilter(c,e,tp)
	return c:IsSetCard(0x6342) and c:IsType(TYPE_MONSTER) and  c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400256.operation2(e,tp,eg,ep,ev,re,r,rp)
		local cm=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
		if cm>2 then cm=2 end
		local g=Duel.GetDecktopGroup(1-tp,cm)
		  Duel.ConfirmCards(tp,g)
		  Duel.SortDecktop(tp,1-tp,cm)
end