--派对狂欢穆克拉
local m=7439219
local cm=_G["c"..m]

cm.named_with_party_time=1

function cm.Party_time(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_party_time
end

function cm.initial_effect(c)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOperation(cm.movop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(cm.spcon)
	e5:SetTarget(cm.sptg)
	e5:SetOperation(cm.spop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e6)
end
function cm.movfilter1(c,seq,e)
	return c:GetSequence()<seq and not c:IsImmuneToEffect(e)
end
function cm.movfilter2(c,seq,e)
	return not c:IsImmuneToEffect(e)
end
function cm.movfilter3(c,seq,e)
	return c:GetSequence()>seq and not c:IsImmuneToEffect(e)
end
function cm.centerfilter1(c,e)
	local seq=c:GetSequence()+1
	local p=c:GetControler()
	if seq>4 then
		seq=seq-5
		p=1-c:GetControler()
	end
	local tc=Duel.GetFieldCard(p,LOCATION_MZONE,seq)
	return (not tc or tc:IsImmuneToEffect(e)) and not c:IsImmuneToEffect(e)
end
function cm.centerfilter2(c,e)
	local seq=c:GetSequence()-1
	local p=c:GetControler()
	if seq<0 then
		seq=seq+5
		p=1-c:GetControler()
	end
	local tc=Duel.GetFieldCard(p,LOCATION_MZONE,seq)
	return (not tc or tc:IsImmuneToEffect(e)) and not c:IsImmuneToEffect(e)
end
function cm.seqminc(g)
	local minc=g:GetFirst()
	local tc=g:GetFirst()
	while tc do
		if tc:GetSequence()<minc:GetSequence() then
			minc=tc
		end
		tc=g:GetNext()
	end
	return minc
end
function cm.seqmaxc(g)
	local maxc=g:GetFirst()
	local tc=g:GetFirst()
	while tc do
		if tc:GetSequence()>maxc:GetSequence() then
			maxc=tc
		end
		tc=g:GetNext()
	end
	return maxc
end
function cm.movop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_MZONE)==0 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
		return false
	end
	if Duel.GetMatchingGroupCount(cm.centerfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)<=0 and Duel.GetMatchingGroupCount(cm.centerfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)<=0 then return false end
	local op=Duel.SelectOption(c:GetOwner(),aux.Stringid(m,3),aux.Stringid(m,4))
	if op==0 then
		local cc=Duel.GetMatchingGroup(cm.centerfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e):GetFirst()
		if not cc then return false end
		local ctp=cc:GetControler()
		local seq=cc:GetSequence()
		local g1=Duel.GetMatchingGroup(cm.movfilter1,ctp,LOCATION_MZONE,0,nil,seq,e)
		local g2=Duel.GetMatchingGroup(cm.movfilter2,ctp,0,LOCATION_MZONE,nil,seq,e)
		local g3=Duel.GetMatchingGroup(cm.movfilter3,ctp,LOCATION_MZONE,0,nil,seq,e)
		local finish=false
		while not finish do
			local mc=cc
			if g3 and g3:GetCount()>0 then
				mc=cm.seqminc(g3)
				g3:RemoveCard(mc)
			else
				if g2 and g2:GetCount()>0 then
					mc=cm.seqminc(g2)
					g2:RemoveCard(mc)
				else
					if g1 and g1:GetCount()>0 then
						mc=cm.seqminc(g1)
						g1:RemoveCard(mc)
					end
				end
			end
			if mc==cc then finish=true end
			local p=mc:GetControler()
			local seq=mc:GetSequence()-1
			if seq<0 then
				seq=seq+5
				p=1-mc:GetControler()
			end
			local zone=1<<seq
			local tc=Duel.GetFieldCard(p,LOCATION_MZONE,seq)
			if (p~=mc:GetControler() and not mc:IsControlerCanBeChanged(true))
				or (Duel.GetMZoneCount(p,nil,mc:GetControler(),LOCATION_REASON_CONTROL,zone)<=0) then
				Duel.SendtoGrave(mc,REASON_EFFECT)
			else
				if p==mc:GetControler() then
					Duel.MoveSequence(mc,seq)
				else
					Duel.GetControl(mc,1-mc:GetControler(),0,0,zone)
				end
			end
		end
	else
		local cc=Duel.GetMatchingGroup(cm.centerfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e):GetFirst()
		if not cc then return false end
		local ctp=cc:GetControler()
		local seq=cc:GetSequence()
		local g1=Duel.GetMatchingGroup(cm.movfilter3,ctp,LOCATION_MZONE,0,nil,seq,e)
		local g2=Duel.GetMatchingGroup(cm.movfilter2,ctp,0,LOCATION_MZONE,nil,seq,e)
		local g3=Duel.GetMatchingGroup(cm.movfilter1,ctp,LOCATION_MZONE,0,nil,seq,e)
		local finish=false
		while not finish do
			local mc=cc
			if g3 and g3:GetCount()>0 then
				mc=cm.seqmaxc(g3)
				g3:RemoveCard(mc)
			else
				if g2 and g2:GetCount()>0 then
					mc=cm.seqmaxc(g2)
					g2:RemoveCard(mc)
				else
					if g1 and g1:GetCount()>0 then
						mc=cm.seqmaxc(g1)
						g1:RemoveCard(mc)
					end
				end
			end
			if mc==cc then finish=true end
			local p=mc:GetControler()
			local seq=mc:GetSequence()+1
			if seq>4 then
				seq=seq-5
				p=1-mc:GetControler()
			end
			local zone=1<<seq
			local tc=Duel.GetFieldCard(p,LOCATION_MZONE,seq)
			if (p~=mc:GetControler() and not mc:IsControlerCanBeChanged(true))
				or (Duel.GetMZoneCount(p,nil,mc:GetControler(),LOCATION_REASON_CONTROL,zone)<=0) then
				Duel.SendtoGrave(mc,REASON_EFFECT)
			else
				if p==mc:GetControler() then
					Duel.MoveSequence(mc,seq)
				else
					Duel.GetControl(mc,1-mc:GetControler(),0,0,zone)
				end
			end
		end
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=false
	local b2=false
	local b3=false
	if re and re:GetHandler() then
		b1=(pl==1-c:GetOwner())
	end
	if c:GetReasonCard() then
		b2=(c:GetReasonCard():GetControler()==1-c:GetOwner())
	end
	if c:GetReasonEffect() and c:GetReasonEffect():GetHandler() then
		b3=(c:GetReasonEffect():GetHandlerPlayer()==1-c:GetOwner())
	end
	return (c:GetReasonPlayer()==1-c:GetOwner() or b1 or b2 or b3) and (not (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
